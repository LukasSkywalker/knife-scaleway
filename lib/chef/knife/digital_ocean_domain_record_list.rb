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
    class DigitalOceanDomainRecordList < Knife
      include Knife::DigitalOceanBase

      banner 'knife digital_ocean domain record list (options)'

      option :id,
        :short       => '-D ID',
        :long        => '--domain-id ID',
        :description => 'The domain id'

      def run
        $stdout.sync = true

        validate!

        unless locate_config_value(:id)
          ui.error("Domain ID cannot be empty. => -D <domain-id>")
          exit 1
        end

        domains_list = [
          h.color('ID', :bold),
          h.color('Type', :bold),
          h.color('Name', :bold),
          h.color('Data', :bold)
        ]

        records = client.domains.list_records(locate_config_value(:id)).records
        records.each do |domain|
          domains_list << domain.id.to_s
          domains_list << domain.record_type.to_s
          domains_list << domain.name.to_s
          domains_list << domain.data.to_s
        end


        puts h.list(domains_list, :uneven_columns_across, 4)
      end

    end
  end
end