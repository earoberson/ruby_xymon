# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ruby_xymon/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Bryan Taylor"]
  gem.email         = ["bcptaylor@gmail.com"]
  gem.description   = %q{ A very simple way to send messages to Xymon }
  gem.summary       = %q{ An incredibly simple way to send messages to Xymon, with no frills at all }
  gem.homepage      = "http://github.com/"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "xymon"
  gem.require_paths = ["lib"]
  gem.version       = RubyXymon::VERSION

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "simplecov"

end
