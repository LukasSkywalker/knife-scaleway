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
    class ScalewayServerResize < Knife
      include Knife::ScalewayBase

      banner 'knife scaleway server resize (options)'

      option :size,
        short: '-s SIZE',
        long: '--size SIZE',
        description: 'Power Action On/Off'

      option :id,
        short: '-I ID',
        long: '--server-id ID',
        description: 'Droplet ID'

      def run
        $stdout.sync = true

        validate!

        unless locate_config_value(:size)
          ui.error('Size cannot be empty. => -s <size>')
          exit 1
        end

        unless locate_config_value(:id)
          ui.error('ID cannot be empty. => -I <id>')
          exit 1
        end

        result = client.server_actions.resize(server_id: locate_config_value(:id), size: locate_config_value(:size))

        unless result.class == DropletKit::Action
          ui.error JSON.parse(result)['message']
          exit 1
        end

        wait_for_status(result)
      end
    end
  end
end
