$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rspec/autorun'
require 'knife-digital_ocean'



Dir['./spec/support/**/*.rb'].sort.each {|f| require f}


