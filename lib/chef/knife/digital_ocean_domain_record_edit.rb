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
    class DigitalOceanDomainRecordEdit < Knife
      include Knife::DigitalOceanBase

      banner 'knife digital_ocean domain record edit (options)'

      option :domain,
             short: '-D NAME',
             long: '--domain-id NAME',
             description: 'The domain name'

      option :record,
             short: '-R ID',
             long: '--record-id ID',
             description: 'The record id'

      option :type,
             short: '-T RECORD TYPE',
             long: '--type RECORD TYPE',
             description: 'The type of record'

      option :name,
             short: '-N RECORD NAME',
             long: '--name RECORD NAME',
             description: 'The record name'

      option :data,
             short: '-a DATA',
             long: '--data DATA',
             description: 'The record data'

      def run
        $stdout.sync = true

        validate!

        unless locate_config_value(:domain)
          ui.error('Domain cannot be empty. => -D <domain-name>')
          exit 1
        end

        unless locate_config_value(:record)
          ui.error('Record cannot be empty. => -R <record-id>')
          exit 1
        end

        unless locate_config_value(:type)
          ui.error('Record type cannot be empty. => -T <record-type>')
          exit 1
        end

        unless locate_config_value(:name)
          ui.error('Record name cannot be empty. => -N <record-name>')
          exit 1
        end

        unless locate_config_value(:data)
          ui.error('Record data cannot be empty. => -d <data>')
          exit 1
        end

        domain_record = DropletKit::DomainRecord.new(
          type: locate_config_value(:type),
          name: locate_config_value(:name),
          data: locate_config_value(:data)
        )
        result = client.domain_records.update domain_record, for_domain: locate_config_value(:domain), id: locate_config_value(:record)
        ui.info 'OK' if result == true or ui.error JSON.parse(result)['message']
      end
    end
  end
end
