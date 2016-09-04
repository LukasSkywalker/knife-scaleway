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
    class ScalewaySshkeyDestroy < Knife
      include Knife::ScalewayBase

      banner 'knife scaleway sshkey destroy (options)'

      option :id,
             short: '-i ID',
             long: '--sshkey-id ID',
             description: 'The ssh key id'

      def run
        $stdout.sync = true

        validate!

        unless locate_config_value(:id)
          ui.error('SSH key id cannot be empty. => -i <id>')
          exit 1
        end

        result = client.ssh_keys.delete id: locate_config_value(:id)
        ui.info 'OK' if result == true || ui.error(JSON.parse(result)['message'])
      end
    end
  end
end
