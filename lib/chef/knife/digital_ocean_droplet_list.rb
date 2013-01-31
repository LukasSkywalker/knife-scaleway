#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2009 Opscode, Inc.
# License:: Apache License, Version 2.0
#
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

require 'digital_ocean'
require 'highline'
require 'chef/knife'
require 'chef/json_compat'
require 'tempfile'

class Chef
  class Knife
    class DigitalOceanDropletList < Knife

      banner 'knife digital_ocean droplet list (options)'

      option :digital_ocean_client_id,
        :short       => '-K CLIENT_ID',
        :long        => '--digital_ocean_client_id CLIENT_ID',
        :description => 'Your DigitalOcean client_id',
        :proc        => Proc.new { |client_id| Chef::Config[:knife][:digital_ocean_client_id] = client_id }

      option :digital_ocean_api_key,
        :short       => '-A API_KEY',
        :long        => '--digital_ocean_api_key API_KEY',
        :description => 'Your DigitalOcean API_KEY',
        :proc        => Proc.new { |api_key| Chef::Config[:knife][:digital_ocean_api_key] = api_key }

      def h
        @highline ||= HighLine.new
      end

      def run
        unless Chef::Config[:knife][:digital_ocean_client_id] && Chef::Config[:knife][:digital_ocean_api_key]
          puts Chef::Config[:knife].inspect
          ui.error("Missing Credentials")
          exit 1
        end

        $stdout.sync = true

        droplet_list = [
            h.color('ID', :bold),
            h.color('Name', :bold),
            h.color('Region', :bold),
            h.color('IP', :bold),
            h.color('Image', :bold),
            h.color('Status', :bold)
        ]

        regions = {}
        client.regions.list.regions.each do |region|
          regions[region.id] = region.name
        end

        client.droplets.list.droplets.each do |droplet|
          droplet_list << droplet.id.to_s
          droplet_list << droplet.name.to_s
          droplet_list << droplet.ip_address.to_s
          droplet_list << regions[droplet.region_id]
          droplet_list << droplet.image_id.to_s + ' (' + client.images.show(droplet.image_id).image.name +  ')'
          droplet_list << droplet.status.to_s
        end

        puts h.list(droplet_list, :columns_across, 6)
      end


      def client
        DigitalOcean::API.new(:client_id => Chef::Config[:knife][:digital_ocean_client_id],
                              :api_key   => Chef::Config[:knife][:digital_ocean_api_key])
      end

    end
  end
end
