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
    class DigitalOceanDomainRecordDestroy < Knife
      include Knife::DigitalOceanBase

      banner 'knife digital_ocean domain record destroy (options)'

      option :domain,
        :short       => '-D NAME',
        :long        => '--domain-id NAME',
        :description => 'The domain name'

      option :record,
        :short       => '-R ID',
        :long        => '--record-id ID',
        :description => 'The record id'

      def run
        $stdout.sync = true

        validate!

        unless locate_config_value(:domain)
          ui.error("Domain cannot be empty. => -D <domain-name>")
          exit 1
        end

        unless locate_config_value(:record)
          ui.error("Record cannot be empty. => -R <record-id>")
          exit 1
        end

        result = client.domain_records.delete for_domain: locate_config_value(:domain), id: locate_config_value(:record)
        ui.error JSON.parse(result)['message'] rescue 'OK'
      end

    end
  end
end
