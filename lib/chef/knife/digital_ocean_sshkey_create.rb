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
    class DigitalOceanSshkeyCreate < Knife
      include Knife::DigitalOceanBase

      banner 'knife digital_ocean sshkey create (options)'

     option :name,
        :short       => '-n NAME',
        :long        => '--sshkey-name NAME',
        :description => 'The ssh key name'

     option :public_key,
        :short       => '-i PUBLIC KEY',
        :long        => '--public-key PUBLIC KEY',
        :description => 'File that contains your public ssh key'

      def run
        $stdout.sync = true

        validate!

        unless locate_config_value(:name)
          ui.error("SSH Key name cannot be empty. => -N <sshkey-name>")
          exit 1
        end

        unless locate_config_value(:public_key)
          ui.error("SSH key file needs to be specified. => -I <public_key>")
          exit 1
        end

        ssh_key = DropletKit::SSHKey.new name: locate_config_value(:name), public_key: File.read(File.expand_path(locate_config_value(:public_key)))
        result = client.ssh_keys.create(ssh_key)
        ui.error JSON.parse(result)['message'] rescue 'OK'
      end
    end
  end
end
