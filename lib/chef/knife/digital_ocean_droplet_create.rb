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
require 'chef/knife/scaleway_base'

class Chef
  class Knife
    class ScalewayServerCreate < Knife
      include Knife::ScalewayBase

      deps do
        require 'socket'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
        Chef::Knife::ScalewayBase.load_deps
        # Knife loads subcommands automatically, so we can just check if the
        # class exists.
        Chef::Knife::SoloBootstrap.load_deps if defined? Chef::Knife::SoloBootstrap
        if defined? Chef::Knife::ZeroBootstrap
          Chef::Knife::ZeroBootstrap.load_deps
          self.options = Chef::Knife::ZeroBootstrap.options.merge(options)
        end
      end

      banner 'knife scaleway droplet create (options)'

      option :server_name,
             short: '-N NAME',
             long: '--server-name NAME',
             description: 'The server name',
             proc: proc { |server_name| Chef::Config[:knife][:server_name] = server_name }

      option :image,
             short: '-I IMAGE',
             long: '--image IMAGE',
             description: 'Your Scaleway Image',
             proc: proc { |image| Chef::Config[:knife][:image] = image }

      option :size,
             short: '-S SIZE',
             long: '--size SIZE',
             description: 'Your Scaleway Size',
             proc: proc { |size| Chef::Config[:knife][:size] = size }

      option :location,
             short: '-L REGION',
             long: '--location REGION',
             description: 'Scaleway Location (Region)',
             proc: proc { |location| Chef::Config[:knife][:location] = location }

      option :ssh_key_ids,
             short: '-K KEYID',
             long: '--ssh-keys KEY_ID',
             description: 'Comma spearated list of your SSH key ids',
             proc: ->(o) { o.split(/[\s,]+/) }

      option :identity_file,
             short: '-i IDENTITY_FILE',
             long: '--identity-file IDENTITY_FILE',
             description: 'The SSH identity file used for authentication',
             proc: proc { |identity| Chef::Config[:knife][:identity_file] = identity }

      option :bootstrap,
             short: '-B',
             long: '--bootstrap',
             description: 'Do a chef-client bootstrap on the created droplet (for use with chef-server)'

      option :solo,
             long: '--[no-]solo',
             description: 'Do a chef-solo bootstrap on the droplet using knife-solo',
             proc: proc { |s| Chef::Config[:knife][:solo] = s }

      option :zero,
             long: '--[no-]zero',
             description: 'Do a chef-zero bootstrap on the droplet using knife-zero',
             proc: proc { |z| Chef::Config[:knife][:zero] = z }

      option :ssh_user,
             short: '-x USERNAME',
             long: '--ssh-user USERNAME',
             description: 'The ssh username; default is "root"',
             default: 'root'

      option :distro,
             short: '-d DISTRO',
             long: '--distro DISTRO',
             description: 'Chef-Bootstrap a distro using a template; default is "chef-full"',
             proc: proc { |d| Chef::Config[:knife][:distro] = d },
             default: 'chef-full'

      option :run_list,
             short: '-r RUN_LIST',
             long: '--run-list RUN_LIST',
             description: 'Comma separated list of roles/recipes to apply',
             proc: ->(o) { o.split(/[\s,]+/) },
             default: []

      option :template_file,
             long: '--template-file TEMPLATE',
             description: 'Full path to location of template to use',
             proc: proc { |t| Chef::Config[:knife][:template_file] = t },
             default: false

      option :host_key_verify,
             long: '--[no-]host-key-verify',
             description: 'Verify host key, enabled by default',
             default: true

      option :prerelease,
             long: '--prerelease',
             description: 'Install the pre-release chef gems'

      option :bootstrap_version,
             long: '--bootstrap-version VERSION',
             description: 'The version of Chef to install',
             proc: proc { |v| Chef::Config[:knife][:bootstrap_version] = v }

      option :environment,
             short: '-E ENVIRONMENT',
             long: '--environment ENVIRONMENT',
             description: 'The name of the chef environment to use',
             proc: proc { |e| Chef::Config[:knife][:environment] = e },
             default: '_default'

      option :json_attributes,
             short: '-j JSON',
             long: '--json-attributes JSON',
             description: 'A JSON string to be added to the first run of chef-client',
             proc: ->(o) { JSON.parse(o) }

      option :private_networking,
             long: '--private_networking',
             description: 'Enables private networking if the selected region supports it',
             default: false

      option :secret_file,
             long: '--secret-file SECRET_FILE',
             description: 'A file containing the secret key to use to encrypt data bag item values',
             proc: proc { |sf| Chef::Config[:knife][:secret_file] = sf }

      option :ssh_port,
             short: '-p PORT',
             long: '--ssh-port PORT',
             description: 'The ssh port',
             default: '22',
             proc: proc { |port| Chef::Config[:knife][:ssh_port] = port }

      option :backups,
             short: '-b',
             long: '--backups-enabled',
             description: 'Enables backups for the created droplet',
             default: false

      option :ipv6,
             short: '-6',
             long: '--ipv6-enabled',
             description: 'Enables ipv6 for the created droplet',
             default: false

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
=begin
        unless locate_config_value(:size)
          ui.error('Size cannot be empty: -S <size>')
          exit 1
        end

        unless locate_config_value(:location)
          ui.error('Location cannot be empty: -L <region>')
          exit 1
        end

        unless locate_config_value(:ssh_key_ids)
          ui.error('One or more Scaleway SSH key ids missing: -K <KEY1>, <KEY2> ...')
          exit 1
        end
=end
        if solo_bootstrap? && !defined?(Chef::Knife::SoloBootstrap)
          ui.error [
            'Knife plugin knife-solo was not found.',
            'Please add the knife-solo gem to your Gemfile or',
            'install it manually with `gem install knife-solo`.'
          ].join(' ')
          exit 1
        end

        if zero_bootstrap? && !defined?(Chef::Knife::ZeroBootstrap)
          ui.error [
            'Knife plugin knife-zero was not found.',
            'Please add the knife-zero gem to your Gemfile or',
            'install it manually with `gem install knife-zero`.'
          ].join(' ')
          exit 1
        end
=begin
        droplet = DropletKit::Droplet.new(name: locate_config_value(:server_name),
                                          size: locate_config_value(:size),
                                          image: locate_config_value(:image),
                                          region: locate_config_value(:location),
                                          ssh_keys: locate_config_value(:ssh_key_ids),
                                          private_networking: locate_config_value(:private_networking),
                                          backups: locate_config_value(:backups),
                                          ipv6: locate_config_value(:ipv6)
                                         )
=end
        server = Scaleway::Server.create(locate_config_value(:server_name), locate_config_value(:image), 'VC1S')

        #server = client.droplets.create(droplet)

        if Scaleway::Server.find(server.id).state != 'stopped'
          ui.error("Droplet could not be started #{server.inspect}")
          exit 1
        end

        puts "Droplet creation for #{locate_config_value(:server_name)} started. Droplet-ID is #{server.id}"

        unless !config.key?(:json_attributes) || config[:json_attributes].empty?
          puts ui.color("JSON Attributes: #{config[:json_attributes]}", :magenta)
        end

        puts "Starting droplet #{server.id}"

        Scaleway::Server.action(server.id, 'poweron')

        print ui.color('Waiting for IPv4-Address', :magenta)
        print('.') until ip_address = ip_address_available(server.id) do
          puts 'done'
        end

        puts ui.color("IPv4 address is: #{ip_address.address}", :green)

        print ui.color('Waiting for sshd:', :magenta)
        print('.') until tcp_test_ssh(ip_address.address) do
          sleep 2
          puts 'done'
        end

        if locate_config_value(:bootstrap) || solo_bootstrap? || zero_bootstrap?
          bootstrap_for_node(ip_address.address).run
        else
          puts ip_address.address
          exit 0
        end
      end

      def ip_address_available(droplet_id)
        server = Scaleway::Server.find(droplet_id)
        if server.public_ip
          yield
          server.public_ip
        else
          sleep @initial_sleep_delay ||= 10
          false
        end
      end

      def tcp_test_ssh(hostname)
        port = Chef::Config[:knife][:ssh_port] || config[:ssh_port]
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
        bootstrap.name_args = [ip_address]
        bootstrap.config.merge! config
        bootstrap.config[:chef_node_name] = locate_config_value(:server_name)
        bootstrap.config[:bootstrap_version] = locate_config_value(:bootstrap_version)
        bootstrap.config[:ssh_port] = Chef::Config[:knife][:ssh_port] || config[:ssh_port]
        bootstrap.config[:distro] = locate_config_value(:distro)
        bootstrap.config[:use_sudo] = true unless config[:ssh_user] == 'root'
        bootstrap.config[:template_file] = locate_config_value(:template_file)
        bootstrap.config[:environment] = locate_config_value(:environment)
        bootstrap.config[:first_boot_attributes] = locate_config_value(:json_attributes) || {}
        bootstrap.config[:secret_file] = locate_config_value(:secret_file) || {}
        bootstrap
      end

      def bootstrap_class
        if solo_bootstrap?
          Chef::Knife::SoloBootstrap
        elsif zero_bootstrap?
          Chef::Knife::ZeroBootstrap
        else
          Chef::Knife::Bootstrap
        end
      end

      def solo_bootstrap?
        config[:solo] || (config[:solo].nil? && Chef::Config[:knife][:solo])
      end

      def zero_bootstrap?
        config[:zero] || (config[:zero].nil? && Chef::Config[:knife][:zero])
      end
    end
  end
end
