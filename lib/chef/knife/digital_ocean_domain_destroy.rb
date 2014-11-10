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
    class DigitalOceanDomainDestroy < Knife
      include Knife::DigitalOceanBase

      banner 'knife digital_ocean domain destroy (options)'

      option :domain,
        :short       => '-D ID',
        :long        => '--domain-id ID',
        :description => 'The domain id'

      def run
        $stdout.sync = true

        validate!

        unless locate_config_value(:domain)
          ui.error("Domain cannot be empty. => -D <domain-id>")
          exit 1
        end

        result = client.domains.delete locate_config_value(:domain)
        puts result.status
      end

    end
  end
end
