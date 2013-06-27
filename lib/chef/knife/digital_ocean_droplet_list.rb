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
            h.color('ID',     :bold),
            h.color('Name',   :bold),
            h.color('Size',   :bold),
            h.color('Region', :bold),
            h.color('IPv4',   :bold),
            h.color('Image',  :bold),
            h.color('Status', :bold)
        ]

        regions = client.regions.list.regions.inject({}) do |h, region|
          h[region.id] = region.name
          h
        end

        sizes = client.sizes.list.sizes.inject({}) do |h, size|
          h[size.id] = size.name
          h
        end

        client.droplets.list.droplets.each do |droplet|
          droplet_list << droplet.id.to_s
          droplet_list << droplet.name.to_s
          droplet_list << sizes[droplet.size_id]
          droplet_list << regions[droplet.region_id]
          droplet_list << droplet.ip_address.to_s

          image_details = client.images.show(droplet.image_id)
          if image_details.status != 'OK'
            image_os_info = 'N/A'
          else
            image_os_info = image_details.image.name 
          end
            
          droplet_list << droplet.image_id.to_s + ' (' + image_os_info +  ')'
          droplet_list << droplet.status.to_s
        end

        puts h.list(droplet_list, :uneven_columns_across, 7)
      end

    end
  end
end
