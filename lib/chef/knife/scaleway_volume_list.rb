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
    class ScalewayVolumeList < Knife
      include Knife::ScalewayBase

      banner 'knife scaleway volume list (options)'

      def run
        $stdout.sync = true

        validate!

        image_list = [
          ui.color('ID',           :bold),
          ui.color('Name',         :bold),
          ui.color('Server',       :bold),
          ui.color('Size',         :bold)
        ]

        volumes = Scaleway::Volume.all

        volumes.each do |volume|
          server_name = volume.server ? volume.server.name : ''
          image_list << volume.id.to_s
          image_list << volume.name.to_s
          image_list << server_name
          image_list << "#{(volume.size.to_i / 1000 / 1000 / 1000)} GB"
        end

        puts ui.list(image_list, :uneven_columns_across, 4)
      end
    end
  end
end
