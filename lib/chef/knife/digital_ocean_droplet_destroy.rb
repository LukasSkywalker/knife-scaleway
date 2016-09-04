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
    class ScalewayServerDestroy < Knife
      include Knife::ScalewayBase

      banner 'knife scaleway droplet destroy (options)'

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

        if locate_config_value(:server)
          droplets_ids = [locate_config_value(:server)]
        elsif locate_config_value(:all)
          ui.error('Warning all servers will be lost unless you exit with ctrl-c now!')

          15.times do |x|
            print x
            print 13.chr
            sleep 1
          end

          droplets_ids = client.droplets.all.map(&:id)
        else
          ui.error 'You need to specify either a --server id or --all'
          exit 1
        end

        if droplets_ids.empty?
          ui.error('Could not find any droplet(s)')
          exit 1
        end

        droplets_ids.each do |id|
          ui.info "Delete droplet with id: #{id}"
          result = client.droplets.delete(id: id)
          ui.info 'OK' if result == true || ui.error(JSON.parse(result)['message'])
        end
      end
    end
  end
end
