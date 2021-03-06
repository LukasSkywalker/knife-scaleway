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
    class ScalewayServerPower < Knife
      include Knife::ScalewayBase

      banner 'knife scaleway server power (options)'

      option :action,
        short: '-a ACTION',
        long: '--action ACTION',
        description: 'Power Action On/Off'

      option :id,
        short: '-I ID',
        long: '--server-id ID',
        description: 'Droplet ID'

      def run
        $stdout.sync = true

        validate!

        unless locate_config_value(:action)
          ui.error('Action cannot be empty. => -a <action>')
          exit 1
        end

        unless locate_config_value(:id)
          ui.error('ID cannot be empty. => -I <id>')
          exit 1
        end

        case locate_config_value(:action)
        when /(on)/i
          poweron = true
          result = Scaleway::Server.action(locate_config_value(:id), 'poweron')
        when /(off)/i
          poweroff = true
          result = Scaleway::Server.action(locate_config_value(:id), 'poweroff')
        else
          ui.error 'Bad Action: Use on/off.'
          exit 1
        end

        unless result.task.description
          #ui.error JSON.parse(result)['message']
          exit 1
        end

        wait_for_status(result, status: 'running') if poweron
        wait_for_status(result, status: 'stopped') if poweroff
      end
    end
  end
end
