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
    class DigitalOceanDropletList < Knife
      include Knife::DigitalOceanBase

      banner 'knife digital_ocean droplet list (options)'

      def run
        $stdout.sync = true

        validate!

        droplet_list = [
          ui.color('ID',     :bold),
          ui.color('Name',   :bold),
          ui.color('Size',   :bold),
          ui.color('Region', :bold),
          ui.color('Image',  :bold),
          ui.color('IPv4',   :bold),
          ui.color('Status', :bold)
        ]
        droplets = client.droplets.all

        droplets.each do |droplet|
          droplet_list << droplet.id.to_s
          droplet_list << droplet.name.to_s
          droplet_list << droplet.size_slug.to_s
          droplet_list << droplet.region.name.to_s
          droplet_list << droplet.image.name.to_s
          droplet_list << droplet.public_ip.to_s
          droplet_list << droplet.status.to_s
        end

        puts ui.list(droplet_list, :uneven_columns_across, 7)
      end
    end
  end
end
