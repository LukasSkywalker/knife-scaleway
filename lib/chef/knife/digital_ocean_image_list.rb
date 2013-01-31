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
require File.expand_path('../digital_ocean_base', __FILE__)

class Chef
  class Knife
    class DigitalOceanImageList < Knife
      include Knife::DigitalOceanBase

      banner 'knife digital_ocean image list (options)'

      option :global_images,
        :short       => '-G',
        :long        => '--global',
        :description => 'Show global images'

      def run
        $stdout.sync = true

        validate!

        image_list = [
            h.color('ID',           :bold),
            h.color('Distribution', :bold),
            h.color('Name',         :bold),
            h.color('Global',       :bold)
        ]

        if config[:global_images]
          filter = 'global'
        else
          filter = 'my_images'
        end

        images = client.images.list(:filter => filter).images

        images.sort! do |a, b|
          [ a.distribution, a.name ] <=> [ b.distribution, b.name ]
        end

        images.each do |image|
          image_list << image.id.to_s
          image_list << image.distribution.to_s
          image_list << image.name.to_s
          image_list << truefalse(config[:global_images])
        end

        puts h.list(image_list, :uneven_columns_across, 4)
      end

      def truefalse(boolean)
        if boolean
          '+'
        else
          '-'
        end
      end

    end
  end
end
