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
    class ScalewayIpList < Knife
      include Knife::ScalewayBase

      banner 'knife scaleway ip list (options)'

      def run
        $stdout.sync = true

        validate!

        ip_list = [
          ui.color('ID',           :bold),
          ui.color('Address',      :bold),
          ui.color('Server',       :bold),
        ]

        ips = Scaleway::Ip.all

        ips.each do |ip|
          server_name = ip.server ? ip.server.name : ''
          ip_list << ip.id.to_s
          ip_list << ip.address.to_s
          ip_list << server_name
        end

        puts ui.list(ip_list, :uneven_columns_across, 3)
      end
    end
  end
end
