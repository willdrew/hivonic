# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require File.expand_path('../lib/hivonic/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'hivonic'
  gem.version       = Hivonic::VERSION
  gem.platform      = Gem::Platform::RUBY
  gem.authors       = ['Will Drew']
  gem.email         = ['willdrew@gmail.com']
  gem.summary       = %q{Tonic oriented utilities for hive (Hive + Tonic => hivonic)}
  gem.description   = %q{Hivonic provides utilities for dealing with temporary hive tables}
  gem.homepage      = 'https://github.com/willdrew/hivonic'

  gem.required_rubygems_version = '>= 1.3.6'
  gem.required_ruby_version = ::Gem::Requirement.new('>= 1.9.3')

  gem.add_dependency('gli', '~> 2.13.0')
  gem.add_development_dependency('rake', '~> 0.9.0')
  gem.add_development_dependency('bundler', '~> 1.3.0')
  gem.add_development_dependency('pry', '~> 0.9.0')
  gem.add_development_dependency('minitest', '~> 2.12.0')
  gem.add_development_dependency('mini_shoulda', '~> 0.4.0')

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

  gem.require_paths = %w(lib)
end
