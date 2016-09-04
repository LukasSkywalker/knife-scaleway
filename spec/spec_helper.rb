$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib', 'chef', 'knife'))
require 'droplet_kit'
require 'hashie'
require 'vcr'
require 'rspec'
require 'chef/knife'
require 'coveralls'
require 'simplecov'
require 'simplecov-console'

require 'chef/knife/scaleway_droplet_create'
require 'chef/knife/scaleway_droplet_destroy'
require 'chef/knife/scaleway_droplet_list'
require 'chef/knife/scaleway_droplet_reboot'
require 'chef/knife/scaleway_droplet_power'
require 'chef/knife/scaleway_droplet_powercycle'
require 'chef/knife/scaleway_droplet_rename'
require 'chef/knife/scaleway_droplet_snapshot'
require 'chef/knife/scaleway_droplet_rebuild'
require 'chef/knife/scaleway_droplet_resize'
require 'chef/knife/scaleway_image_list'
require 'chef/knife/scaleway_region_list'
require 'chef/knife/scaleway_size_list'
require 'chef/knife/scaleway_sshkey_list'
require 'chef/knife/scaleway_sshkey_create'
require 'chef/knife/scaleway_sshkey_destroy'
require 'chef/knife/scaleway_domain_list'
require 'chef/knife/scaleway_domain_create'
require 'chef/knife/scaleway_domain_destroy'
require 'chef/knife/scaleway_domain_record_list'
require 'chef/knife/scaleway_domain_record_create'
require 'chef/knife/scaleway_domain_record_edit'
require 'chef/knife/scaleway_domain_record_destroy'
require 'chef/knife/scaleway_account_info'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data('FAKE_ACCESS_TOKEN') { ENV['DIGITALOCEAN_ACCESS_TOKEN'] }

  c.before_record do |interaction|
    filter_headers(interaction, 'Set-Cookie', '_COOKIE_ID_')
  end
end

# Clear config between each example
# to avoid dependencies between examples
RSpec.configure do |c|
  c.before(:each) do
    Chef::Config.reset
    Chef::Config[:knife] = {}
  end
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::Console
]
SimpleCov.start

# Cleverly borrowed from knife-rackspace, thank you!
def filter_headers(interaction, pattern, placeholder)
  [interaction.request.headers, interaction.response.headers].each do |headers|
    sensitive_tokens = headers.select { |key| key.to_s.match(pattern) }
    sensitive_tokens.each do |key, _value|
      headers[key] = placeholder
    end
  end
end
