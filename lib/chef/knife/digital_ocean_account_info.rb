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
    class DigitalOceanAccountInfo < Knife
      include Knife::DigitalOceanBase

      banner 'knife digital_ocean account info (options)'

      def run
        $stdout.sync = true

        validate!

        account_info = [
          ui.color('UUID',           :bold),
          ui.color('Email',          :bold),
          ui.color('Droplet Limit',  :bold),
          ui.color('Email Verified', :bold)
        ]

        account = client.account.info

        account_info << account.uuid.to_s
        account_info << account.email.to_s
        account_info << account.droplet_limit.to_s
        account_info << account.email_verified.to_s

        puts ui.list(account_info, :uneven_columns_across, 4)
      end
    end
  end
end
