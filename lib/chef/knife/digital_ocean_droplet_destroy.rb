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
    class DigitalOceanDropletDestroy < Knife
      include Knife::DigitalOceanBase

      banner 'knife digital_ocean droplet destroy (options)'

      option :server,
             short: '-S ID',
             long: '--server ID',
             description: 'The server id'

      def run
        $stdout.sync = true

        validate!

        unless locate_config_value(:server)
          ui.error('Server cannot be empty. ALL DATA WILL BE LOST! => -S <server-id>')
          exit 1
        end

        result = client.droplets.delete(id: locate_config_value(:server))
        puts JSON.parse(result)['message'] rescue ''
      end
    end
  end
end
