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
    class ScalewayDomainList < Knife
      include Knife::ScalewayBase

      banner 'knife scaleway domain list'

      def run
        $stdout.sync = true

        validate!

        domains_list = [
          ui.color('Name', :bold),
          ui.color('TTL', :bold)
        ]

        domains = client.domains.all

        domains.sort_by(&:name).each do |domain|
          domains_list << domain.name.to_s
          domains_list << domain.ttl.to_s
        end

        puts ui.list(domains_list, :uneven_columns_across, 2)
      end
    end
  end
end
