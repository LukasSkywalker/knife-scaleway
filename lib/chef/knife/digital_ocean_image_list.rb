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
    class DigitalOceanImageList < Knife
      include Knife::DigitalOceanBase

      banner 'knife digital_ocean image list (options)'

      option :public_images,
             short: '-P',
             long: '--public',
             description: 'Show public images'

      def run
        $stdout.sync = true

        validate!

        image_list = [
          ui.color('ID',           :bold),
          ui.color('Distribution', :bold),
          ui.color('Name',         :bold),
          ui.color('Slug',         :bold)
        ]

        images = Scaleway::Image.all

        if config[:public_images]
          found_images = images.find_all { |i| i.public == true }
        else
          found_images = images.find_all { |i| i.public == false }
        end

        found_images.each do |image|
          image_list << image.id.to_s
          image_list << image.arch.to_s
          image_list << image.name.to_s
          image_list << image.public.to_s
        end

        puts ui.list(image_list, :uneven_columns_across, 4)
      end
    end
  end
end
