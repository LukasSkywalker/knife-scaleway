$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rspec/autorun'

require 'digital_ocean'
require 'rash'

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

Dir['./spec/support/**/*.rb'].sort.each {|f| require f}
