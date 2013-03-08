# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'chef/knife/digital_ocean_base'

class Chef
  class Knife
    class DigitalOceanDropletCreate < Knife
      include Knife::DigitalOceanBase

      deps do
        require 'socket'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
        Chef::Knife::DigitalOceanBase.load_deps
        # Knife loads subcommands automatically, so we can just check if the
        # class exists.
        Chef::Knife::SoloBootstrap.load_deps if defined? Chef::Knife::SoloBootstrap
      end

      banner 'knife digital_ocean droplet create (options)'

      option :server_name,
        :short       => '-N NAME',
        :long        => '--server-name NAME',
        :description => 'The server name',
        :proc        => Proc.new { |server_name| Chef::Config[:knife][:server_name] = server_name }

      option :image,
        :short       => '-I IMAGE',
        :long        => '--image IMAGE',
        :description => 'Your DigitalOcean Image',
        :proc        => Proc.new { |image| Chef::Config[:knife][:image] = image }

      option :size,
        :short       => '-S SIZE',
        :long        => '--size SIZE',
        :description => 'Your DigitalOcean Size',
        :proc        => Proc.new { |size| Chef::Config[:knife][:size] = size }

      option :location,
        :short       => '-L REGION',
        :long        => '--location REGION',
        :description => 'DigitalOcean Location (Region)',
        :proc        => Proc.new { |location| Chef::Config[:knife][:location] = location }

      option :ssh_key_ids,
        :short       => '-K KEYID',
        :long        => '--ssh-keys KEY_ID',
        :description => 'Comma spearated list of your SSH key ids',
        :proc        => lambda { |o| o.split(/[\s,]+/) }

      option :identity_file,
        :short       => '-i IDENTITY_FILE',
        :long        => '--identity-file IDENTITY_FILE',
        :description => 'The SSH identity file used for authentication',
        :proc        => Proc.new { |identity| Chef::Config[:knife][:identity_file] = identity }

      option :bootstrap,
        :short       => '-B',
        :long        => '--bootstrap',
        :description => 'Do a chef-client bootstrap on the created droplet (for use with chef-server)'

      option :solo,
        :long        => '--[no-]solo',
        :description => 'Do a chef-solo bootstrap on the droplet using knife-solo',
        :proc        => Proc.new { |s| Chef::Config[:knife][:solo] = s }

      option :ssh_user,
        :short       => '-x USERNAME',
        :long        => '--ssh-user USERNAME',
        :description => 'The ssh username; default is "root"',
        :default     => 'root'

      option :distro,
        :short       => '-d DISTRO',
        :long        => '--distro DISTRO',
        :description => 'Chef-Bootstrap a distro using a template; default is "chef-full"',
        :proc        => Proc.new { |d| Chef::Config[:knife][:distro] = d },
        :default     => 'chef-full'

      option :run_list,
        :short       => '-r RUN_LIST',
        :long        => '--run-list RUN_LIST',
        :description => 'Comma separated list of roles/recipes to apply',
        :proc        => lambda { |o| o.split(/[\s,]+/) },
        :default     => []

      option :template_file,
        :long        => "--template-file TEMPLATE",
        :description => "Full path to location of template to use",
        :proc        => Proc.new { |t| Chef::Config[:knife][:template_file] = t },
        :default     => false

      option :host_key_verify,
        :long        => "--[no-]host-key-verify",
        :description => "Verify host key, enabled by default",
        :default     => true

      option :prerelease,
        :long        => "--prerelease",
        :description => "Install the pre-release chef gems"

      option :bootstrap_version,
        :long        => "--bootstrap-version VERSION",
        :description => "The version of Chef to install",
        :proc        => Proc.new { |v| Chef::Config[:knife][:bootstrap_version] = v }

      def run
        $stdout.sync = true

        validate!

        unless locate_config_value(:server_name)
          ui.error('Server Name cannot be empty: -N <servername>')
          exit 1
        end

        unless locate_config_value(:image)
          ui.error('Image cannot be empty: -I <image>')
          exit 1
        end

        unless locate_config_value(:size)
          ui.error('Size cannot be empty: -S <size>')
          exit 1
        end

        unless locate_config_value(:location)
          ui.error('Location cannot be empty: -L <region>')
          exit 1
        end

        unless locate_config_value(:ssh_key_ids)
          ui.error('One or more DigitalOcean SSH key ids missing: -K <KEY1>, <KEY2> ...')
          exit 1
        end

        if solo_bootstrap? && !defined?(Chef::Knife::SoloBootstrap)
          ui.error [
            'Knife plugin knife-solo was not found.',
            'Please add the knife-solo gem to your Gemfile or',
            'install it manually with `gem install knife-solo`.'
          ].join(" ")
          exit 1
        end

        response = client.droplets.create(:name        => locate_config_value(:server_name),
                                          :size_id     => locate_config_value(:size),
                                          :image_id    => locate_config_value(:image),
                                          :region_id   => locate_config_value(:location),
                                          :ssh_key_ids => locate_config_value(:ssh_key_ids).join(','))

        if response.status != 'OK'
          ui.error("Droplet could not be started #{response.inspect}")
          exit 1
        end

        puts "Droplet creation for #{locate_config_value(:server_name)} started. Droplet-ID is #{response.droplet.id}"

        print ui.color("Waiting for IPv4-Address", :magenta)
        print(".") until ip_address = ip_address_available(response.droplet.id) {
          puts 'done'
        }

        puts ui.color("IPv4 address is: #{ip_address}", :green)

        print ui.color('Waiting for sshd:', :magenta)
        print('.') until tcp_test_ssh(ip_address, 22) {
          sleep 2
          puts 'done'
        }

        if locate_config_value(:bootstrap) || solo_bootstrap?
          bootstrap_for_node(ip_address).run
        else
          puts ip_address
          exit 0
        end

      end

      def ip_address_available(droplet_id)
        response = client.droplets.show(droplet_id)
        if response.droplet.ip_address
          yield
          response.droplet.ip_address
        else
          sleep @initial_sleep_delay ||= 10
          false
        end
      end

      def tcp_test_ssh(hostname, port)
        tcp_socket = TCPSocket.new(hostname, port)
        readable = IO.select([tcp_socket], nil, nil, 5)
        if readable
          Chef::Log.debug("sshd accepting connections on #{hostname}, banner is #{tcp_socket.gets}")
          yield
          true
        else
          false
        end
      rescue Errno::ETIMEDOUT
        false
      rescue Errno::EPERM
        false
      rescue Errno::ECONNREFUSED
        sleep 2
        false
      rescue Errno::EHOSTUNREACH
        sleep 2
        false
      ensure
        tcp_socket && tcp_socket.close
      end

      def bootstrap_for_node(ip_address)
        bootstrap = bootstrap_class.new
        bootstrap.name_args = [ ip_address ]
        bootstrap.config.merge! config
        bootstrap.config[:chef_node_name] = locate_config_value(:server_name)
        bootstrap.config[:bootstrap_version] = locate_config_value(:bootstrap_version)
        bootstrap.config[:distro] = locate_config_value(:distro)
        bootstrap.config[:use_sudo] = true unless config[:ssh_user] == 'root'
        bootstrap.config[:template_file] = locate_config_value(:template_file)
        bootstrap
      end

      def bootstrap_class
        solo_bootstrap? ? Chef::Knife::SoloBootstrap : Chef::Knife::Bootstrap
      end

      def solo_bootstrap?
        config[:solo] || (config[:solo].nil? && Chef::Config[:knife][:solo])
      end
    end
  end
end
