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
    class DigitalOceanSshkeyList < Knife
      include Knife::DigitalOceanBase

      banner 'knife digital_ocean sshkey list'

      def run
        $stdout.sync = true

        validate!

        sshkey_list = [
          ui.color('ID',   :bold),
          ui.color('Name', :bold),
          ui.color('Fingerprint', :bold)
        ]

        sshkeys = client.ssh_keys.all

        sshkeys.each do |sshkey|
          sshkey_list << sshkey.id.to_s
          sshkey_list << sshkey.name.to_s
          sshkey_list << sshkey.fingerprint.to_s
        end

        puts ui.list(sshkey_list, :uneven_columns_across, 3)
      end
    end
  end
end
