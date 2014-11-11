$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'droplet_kit'
require 'hashie'
require 'vcr'

require 'chef/knife'
require 'chef/knife/digital_ocean_droplet_create'
require 'chef/knife/digital_ocean_droplet_destroy'
require 'chef/knife/digital_ocean_droplet_list'
require 'chef/knife/digital_ocean_image_list'
require 'chef/knife/digital_ocean_region_list'
require 'chef/knife/digital_ocean_size_list'
require 'chef/knife/digital_ocean_sshkey_list'
require 'chef/knife/digital_ocean_domain_list'
require 'chef/knife/digital_ocean_domain_create'
require 'chef/knife/digital_ocean_domain_destroy'
require 'chef/knife/digital_ocean_domain_record_list'
require 'chef/knife/digital_ocean_domain_record_create'
require 'chef/knife/digital_ocean_domain_record_edit'
require 'chef/knife/digital_ocean_domain_record_destroy'
require 'chef/knife/digital_ocean_account_info'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data('FAKE_ACCESS_TOKEN') { ENV['DIGITALOCEAN_ACCESS_TOKEN'] }
end
