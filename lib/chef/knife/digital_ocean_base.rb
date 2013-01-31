# lots of awesome stoff stolen from opscode/knife-azure ;-)
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
class Chef
  class Knife
    module DigitalOceanBase

      def self.included(includer)
        includer.class_eval do

          deps do
            require 'digital_ocean'
            require 'highline'
            require 'readline'
            require 'chef/json_compat'
          end

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
        end
      end

      def h
        @highline ||= HighLine.new
      end

      def client
        DigitalOcean::API.new(:client_id => Chef::Config[:knife][:digital_ocean_client_id],
                              :api_key   => Chef::Config[:knife][:digital_ocean_api_key])
      end

      def validate!(keys=[:digital_ocean_client_id, :digital_ocean_api_key])
        errors = []

        keys.each do |k|
          if locate_config_value(k).nil?
            errors << "You did not provide a valid '#{k}' value. Please set knife[:#{k}] in your knife.rb or pass as an option."
          end
        end

        if errors.each{|e| ui.error(e)}.any?
          exit 1
        end
      end

      def locate_config_value(key)
        key = key.to_sym
        config[key] || Chef::Config[:knife][key]
      end
    end
  end
end
