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
    class DigitalOceanDropletDestroy < Knife
      include Knife::DigitalOceanBase

      banner 'knife digital_ocean droplet destroy (options)'

      option :server,
             short: '-S ID',
             long: '--server ID',
             description: 'The server id'

      option :all,
             short: '-a',
             long: '--all',
             description: '!WARNING! UNRECOVERABLE Destroy all droplets.'

      def run
        $stdout.sync = true

        validate!

        droplets_ids = []

        unless locate_config_value(:server)
          ui.error('Server cannot be empty. => -S <server-id>')
          exit 1
        end

        unless locate_config_value(:all)
          ui.error('Warning all servers will be lost unless you exit with ctrl-c now!')
          15.times{|x| print x; print 13.chr; sleep 15}
        end

        if locate_config_value(:all) && !client.droplets
          ui.error('You don`t have droplets')
          exit 1
        end

        if locate_config_value(:server)
          droplets_ids = [locate_config_value(:server)]
        end

        if locate_config_value(:all)
          droplets_ids = client.droplets.all.map(&:id)
        end

        droplets_ids.each do |id|
          ui.info "Delete droplet with id: #{id}"
          result = client.droplets.delete(id: id)
          ui.info 'OK' if result == true or ui.error JSON.parse(result)['message']
        end
      end
    end
  end
end
