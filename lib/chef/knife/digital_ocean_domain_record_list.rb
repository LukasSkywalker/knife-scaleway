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

class Chef
  class Knife
    class ScalewayDomainRecordList < Knife
      include Knife::ScalewayBase

      banner 'knife scaleway domain record list (options)'

      option :name,
             short: '-D NAME',
             long: '--domain-name NAME',
             description: 'The domain name'

      def run
        $stdout.sync = true

        validate!

        unless locate_config_value(:name)
          ui.error('Domain Name cannot be empty. => -D <domain-name>')
          exit 1
        end

        domains_list = [
          ui.color('ID', :bold),
          ui.color('Type', :bold),
          ui.color('Name', :bold),
          ui.color('Data', :bold)
        ]

        records = client.domain_records.all for_domain: locate_config_value(:name)
        records.each do |domain|
          domains_list << domain.id.to_s
          domains_list << domain.type.to_s
          domains_list << domain.name.to_s
          domains_list << domain.data.to_s
        end

        puts ui.list(domains_list, :uneven_columns_across, 4)
      end
    end
  end
end
