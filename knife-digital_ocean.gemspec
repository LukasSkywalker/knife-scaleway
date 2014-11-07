# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'knife-digital_ocean/version'

Gem::Specification.new do |gem|
  gem.name          = 'knife-digital_ocean'
  gem.version       = Knife::DigitalOcean::VERSION
  gem.authors       = ['Roland Moriz', 'Greg Fitzgerald']
  gem.email         = ['roland@moriz.de', 'greg@gregf.org']
  gem.description   = "A plugin for chef's knife to manage instances of DigitalOcean servers"
  gem.summary       = "A plugin for chef's knife to manage instances of DigitalOcean servers"
  gem.homepage      = 'https://github.com/rmoriz/knife-digital_ocean'
  gem.license       = 'Apache 2.0'

  gem.add_dependency 'chef', '>= 10.18'
  gem.add_dependency 'droplet_kit', '~> 1.1.2'

  gem.add_development_dependency 'rspec', '~> 3.1'
  gem.add_development_dependency 'rubocop', '~> 0.27'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'knife-solo'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
