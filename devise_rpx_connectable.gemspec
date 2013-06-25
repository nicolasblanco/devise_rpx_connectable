# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'devise_rpx_connectable/version'

Gem::Specification.new do |gem|
  gem.name          = "devise_rpx_connectable"
  gem.version       = Devise::RpxConnectable::VERSION
  gem.authors       = ["Nicolas Blanco"]
  gem.email         = ["slainer68@gmail.com"]
  gem.description   = %q{Authenticate your users with RPX in your Rails application using Devise}
  gem.summary       = %q{Devise << RPX}
  gem.homepage      = "https://github.com/slainer68/devise_rpx_connectable"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency(%q<devise>, [">= 2.1.2"])
  gem.add_runtime_dependency(%q<rpx_now>, ["~> 0.7.0"])

  gem.add_development_dependency(%q<bundler>, ["> 1.1.0"])
  gem.add_development_dependency(%q<rake>, ["~> 0.9.2.2"])
  gem.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
  gem.add_development_dependency(%q<rdoc>, ["~> 3.11"])
end
