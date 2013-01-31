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
require File.expand_path('../digital_ocean_base', __FILE__)

class Chef
  class Knife
    class DigitalOceanDropletCreate < Knife
      include Knife::DigitalOceanBase

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

      # FIXME splitting + kniferb
      option :ssh_key_ids,
        :short       => '-K KEYID',
        :long        => '--ssh-keys KEY_ID',
        :description => 'Comma spearated list of your SSH key ids',
        :proc        => lambda { |o| o.split(/[\s,]+/) }

      option :ssh_user,
        :short => "-x USERNAME",
        :long => "--ssh-user USERNAME",
        :description => "The ssh username; default is 'root'",
        :default => "root"

      option :distro,
        :short => "-d DISTRO",
        :long => "--distro DISTRO",
        :description => "Chef-Bootstrap a distro using a template; default is 'ubuntu10.04-gems'",
        :proc => Proc.new { |d| Chef::Config[:knife][:distro] = d },
        :default => "ubuntu10.04-gems"

      option :run_list,
        :short => "-r RUN_LIST",
        :long => "--run-list RUN_LIST",
        :description => "Comma separated list of roles/recipes to apply",
        :proc => lambda { |o| o.split(/[\s,]+/) },
        :default => []

      def run
        $stdout.sync = true

        validate!

        unless locate_config_value(:server_name)
          ui.error("Server Name cannot be empty: -N <servername>")
          exit 1
        end

        unless locate_config_value(:image)
          ui.error("Image cannot be empty: -I <image>")
          exit 1
        end

        unless locate_config_value(:size)
          ui.error("Size cannot be empty: -S <size>")
          exit 1
        end

        unless locate_config_value(:location)
          ui.error("Location cannot be empty: -L <region>")
          exit 1
        end

        unless locate_config_value(:ssh_key_ids)
          ui.error("One or more DigitalOcean SSH key ids missing: -K <KEY1>, <KEY2> ...")
          exit 1
        end

        droplet = client.droplets.create(:name        => locate_config_value(:server_name),
                                         :size_id     => locate_config_value(:size),
                                         :image_id    => locate_config_value(:image),
                                         :region_id   => locate_config_value(:location),
                                         :ssh_key_ids => locate_config_value(:ssh_key_ids).join(','))

        puts droplet.inspect
      end

    end
  end
end
