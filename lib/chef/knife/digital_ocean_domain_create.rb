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
    class ScalewayDomainCreate < Knife
      include Knife::ScalewayBase

      banner 'knife digital_ocean domain create (options)'

      option :name,
             short: '-N NAME',
             long: '--name NAME',
             description: 'The domain name'

      option :ip_address,
             short: '-I IP Address',
             long: '--ip-address address',
             description: 'The ip address'

      def run
        $stdout.sync = true

        validate!

        unless locate_config_value(:name)
          ui.error('Name cannot be empty. => -N <domain-name>')
          exit 1
        end

        unless locate_config_value(:ip_address)
          ui.error('IP Address cannot be empty. => -I <ip-address>')
          exit 1
        end

        domain = DropletKit::Domain.new ip_address: locate_config_value(:ip_address), name: locate_config_value(:name)
        result = client.domains.create domain
        ui.info 'OK' if result.class == DropletKit::Domain || ui.error(JSON.parse(result)['message'])
      end
    end
  end
end
