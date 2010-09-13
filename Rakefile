# encoding: utf-8
require 'rubygems'
require 'rake'
require 'rake/rdoctask'
require File.join(File.dirname(__FILE__), 'lib', 'devise_rpx_connectable', 'version')

NAME = "devise_rpx_connectable"

begin
  gem 'jeweler'
  require 'jeweler'
  Jeweler::Tasks.new do |spec|
    spec.name         = NAME
    spec.version      = ::Devise::RpxConnectable::VERSION
    spec.summary      = %{Devise << RPX}
    spec.description  = spec.summary
    spec.homepage     = "http://github.com/slainer68/#{spec.name}"
    spec.authors      = ["Nicolas Blanco"]
    spec.email        = "slainer68@gmail.com"

    spec.files = FileList['[A-Z]*', File.join(*%w[{lib,rails} ** *]).to_s]

    spec.add_dependency 'devise',           '>= 1.2.0'
    spec.add_dependency 'rpx_now',          '>= 0.6.19'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler - or one of its dependencies - is not available. " <<
        "Install it with: sudo gem install jeweler -s http://gemcutter.org"
end
