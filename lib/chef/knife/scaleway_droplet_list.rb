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
    class ScalewayServerList < Knife
      include Knife::ScalewayBase

      banner 'knife scaleway server list (options)'

      def run
        $stdout.sync = true

        validate!

        server_list = [
          ui.color('ID',     :bold),
          ui.color('Name',   :bold),
          ui.color('Size',   :bold),
          ui.color('Region', :bold),
          ui.color('IPv4',   :bold),
          ui.color('Image',  :bold),
          ui.color('Status', :bold)
        ]
        servers = Scaleway::Server.all

        servers.each do |server|
          ip = server.public_ip ? server.public_ip.address.to_s : ''.to_s

          server_list << server.id.to_s
          server_list << server.name.to_s
          server_list << '?' # server.size_slug.to_s
          server_list << 'fr-1' # server.region.name.to_s
          server_list << ip
          server_list << server.image.name.to_s
          server_list << server.state.to_s
        end

        puts ui.list(server_list, :uneven_columns_across, 7)
      end
    end
  end
end
