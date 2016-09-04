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
    class ScalewayImageDestroy < Knife
      include Knife::ScalewayBase

      banner 'knife scaleway image destroy (options)'

      option :id,
             short: '-I ID',
             long: '--image-id ID',
             description: 'The image ID'

      def run
        $stdout.sync = true

        validate!

        unless locate_config_value(:id)
          ui.error('Image ID cannot be empty. => -I <image-id>')
          exit 1
        end

        result = client.images.delete(id: locate_config_value(:id))
        ui.info 'OK' if result == true || ui.error(JSON.parse(result)['message'])
      end
    end
  end
end
