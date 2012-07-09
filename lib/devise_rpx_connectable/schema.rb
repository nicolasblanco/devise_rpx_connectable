# # encoding: utf-8
# require 'devise/schema'
# 
# module Devise #:nodoc:
#   module RpxConnectable #:nodoc:
# 
#     module Schema
# 
#       # Database migration schema for RPX.
#       #
#       def rpx_connectable
#         apply_devise_schema ::Devise.rpx_identifier_field, String, :limit => 255
#       end
# 
#     end
#   end
# end
# 
# Devise::Schema.module_eval do
#   include ::Devise::RpxConnectable::Schema
# end
