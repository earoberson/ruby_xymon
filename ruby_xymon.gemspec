# -*- encoding: utf-8 -*-
require 'base64'
require File.expand_path('../lib/ruby_xymon/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Bryan Taylor"]
  gem.email         = ['YmNwdGF5bG9yQGdtYWlsLmNvbQ==\n'].collect{ |foo| Base64.decode64(foo) }
  gem.description   = %q{ A very simple way to send messages to Xymon }
  gem.summary       = %q{ An incredibly simple way to send messages to Xymon, with no frills at all }
  gem.homepage      = "http://github.com/rubyisbeautiful/ruby_xymon"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "ruby_xymon"
  gem.require_paths = ["lib"]
  gem.version       = RubyXymon::VERSION


end
