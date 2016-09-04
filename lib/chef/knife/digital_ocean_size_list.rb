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
    class ScalewaySizeList < Knife
      include Knife::ScalewayBase

      banner 'knife scaleway size list (options)'

      def run
        $stdout.sync = true

        validate!

        size_list = [
          ui.color('Slug', :bold)
        ]

        sizes = client.sizes.all

        sizes.each do |size|
          size_list << size.slug
        end

        puts ui.list(size_list, :uneven_columns_across, 1)
      end
    end
  end
end
