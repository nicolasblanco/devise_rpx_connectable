# encoding: utf-8
require 'devise'
require 'rpx_now'

require 'devise_rpx_connectable/model'
require 'devise_rpx_connectable/strategy'
require 'devise_rpx_connectable/schema'
require 'devise_rpx_connectable/view_helpers'

module Devise
  mattr_accessor :rpx_identifier_field
  @@rpx_identifier_field = :rpx_identifier
  
  mattr_accessor :rpx_auto_create_account
  @@rpx_auto_create_account = true
  
  mattr_accessor :rpx_application_name
  @@rpx_application_name = nil
end

I18n.load_path.unshift File.join(File.dirname(__FILE__), *%w[devise_rpx_connectable locales en.yml])

Devise.add_module(:rpx_connectable,
  :strategy => true,
  :controller => :sessions,
  :model => 'devise_rpx_connectable/model')
