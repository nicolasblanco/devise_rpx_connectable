# encoding: utf-8
unless defined?(Devise)
  require 'devise'
end
unless defined?(RPXNow)
  require 'rpx_now'
end

require 'devise_rpx_connectable/model'
require 'devise_rpx_connectable/strategy'
Warden::Strategies.add(:rpx_connectable, Devise::RpxConnectable::Strategies::RpxConnectable)

require 'devise_rpx_connectable/view_helpers'

module Devise
  mattr_accessor :rpx_identifier_field
  @@rpx_identifier_field = :rpx_identifier

  mattr_accessor :rpx_auto_create_account
  @@rpx_auto_create_account = true

  mattr_accessor :rpx_extended_user_data
  @@rpx_extended_user_data = true

  mattr_accessor :rpx_additional_user_data
  @@rpx_additional_user_data = []

  mattr_accessor :rpx_application_name
  @@rpx_application_name = nil
end

I18n.load_path.unshift File.join(File.dirname(__FILE__), *%w[devise_rpx_connectable locales en.yml])

Devise.add_module(:rpx_connectable, {
  :controller => :sessions,
  :model => 'devise_rpx_connectable/model',
  :route => { :session => [nil, :new, :destroy] },
  :strategy => true
})
