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
    class ScalewayImageTransfer < Knife
      include Knife::DigitalOceanBase

      banner 'knife digital_ocean image transfer (options)'

      option :id,
             short: '-I ID',
             long: '--image-id ID',
             description: 'The image ID'

      option :region,
             short: '-R REGION',
             long: '--region REGION',
             description: 'The region name'

      def run
        $stdout.sync = true

        validate!

        unless locate_config_value(:id)
          ui.error('Image ID cannot be empty. => -I <image-id>')
          exit 1
        end

        unless locate_config_value(:region)
          ui.error('Image ID cannot be empty. => -R <region>')
          exit 1
        end

        result = client.image_actions.transfer(image_id: locate_config_value(:id), region: locate_config_value(:region))

        unless result.class == DropletKit::ImageAction
          ui.error JSON.parse(result)['message']
          exit 1
        end

        print 'Waiting '
        while result.status == 'in-progress'
          sleep 8
          print('.')

          break if client.images.find(id: locate_config_value(:id))
                   .regions.include? locate_config_value(:region)
        end
        ui.info 'OK'
      end
    end
  end
end
