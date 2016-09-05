# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'knife-scaleway/version'

Gem::Specification.new do |gem|
  gem.name          = 'knife-scaleway'
  gem.version       = Knife::Scaleway::VERSION
  gem.authors       = ['Lukas Diener']
  gem.email         = ['lukas.diener@hotmail.com']
  gem.description   = "A plugin for chef's knife to manage instances of Scaleway servers"
  gem.summary       = "A plugin for chef's knife to manage instances of Scaleway servers"
  gem.homepage      = 'https://github.com/LukasSkywalker/knife-scaleway'
  gem.license       = 'Apache 2.0'

  gem.add_dependency 'chef', '>= 10.18'

  gem.add_development_dependency 'rspec', '~> 3.1'
  gem.add_development_dependency 'rubocop', '~> 0.27'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'knife-solo'
  gem.add_development_dependency 'knife-zero'
  gem.add_development_dependency 'webmock', '~> 1.20'
  gem.add_development_dependency 'vcr', '~> 2.9'
  gem.add_development_dependency 'guard', '~> 2.8'
  gem.add_development_dependency 'guard-rspec', '~> 4.3'
  gem.add_development_dependency 'coveralls'
  gem.add_development_dependency 'countloc'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'simplecov-console'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
