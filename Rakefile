require "rake"
require "rake/rdoctask"
require "rspec"
require "rspec/core/rake_task"
require File.join(File.dirname(__FILE__), 'lib', 'devise_rpx_connectable', 'version')

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "devise_rpx_connectable"
    gem.version = ::Devise::RpxConnectable::VERSION
    gem.summary = %Q{Authenticate your users with RPX in your Rails application using Devise.}
    gem.description = %Q{Authenticate your users with RPX in your Rails application using Devise.}
    gem.email = "slainer68@gmail.com"
    gem.homepage = "http://github.com/slainer68/devise_rpx_connectable"
    gem.authors = ["Nicolas Blanco"]
    
    gem.add_dependency 'devise',           '>= 1.1.2'
    gem.add_dependency 'rpx_now',          '>= 0.6.23'
    
    gem.add_development_dependency "rspec", ">= 2.0.0.beta.22"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

Rspec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "devise_rpx_connectable #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

