# encoding: utf-8
require 'devise/strategies/base'

module Devise #:nodoc:
  module RpxConnectable #:nodoc:
    module Strategies #:nodoc:

      # Default strategy for signing in a user using RPX.
      # Redirects to sign_in page if it's not authenticated
      #
      class RpxConnectable < ::Devise::Strategies::Base

        def valid?
          valid_controller? && valid_params? && mapping.to.respond_to?('authenticate_with_rpx')
        end

        # Authenticate user with RPX.
        #
        def authenticate!
          klass = mapping.to
          raise StandardError, "RPXNow API key is not defined, please see the documentation of RPXNow gem to setup it." unless RPXNow.api_key.present?
          begin
            rpx_user = (RPXNow.user_data(params[:token], :extended => klass.rpx_extended_user_data, :additional => klass.rpx_additional_user_data) rescue nil)
            fail!(:rpx_invalid) and return unless rpx_user
            
            if user = klass.authenticate_with_rpx(:identifier => rpx_user["identifier"])
              success!(user)
            else
              if klass.rpx_auto_create_account?
                user = klass.new.tap do |u|
                  u.store_rpx_credentials!(rpx_user)
                  u.on_before_rpx_connect(rpx_user)
                end
                begin
                  user.save(:validate => false)
                  user.on_after_rpx_connect(rpx_user)
                  success!(user)
                rescue
                  fail!(:rpx_invalid)
                end
              else
                fail!(:rpx_invalid)
              end
            end
          rescue => e
            fail!(e.message)
          end
        end
        
        protected
          def valid_controller?
            params[:controller].to_s =~ /sessions/
          end

          def valid_params?
            params[:token].present?
          end

      end
    end
  end
end

Warden::Strategies.add(:rpx_connectable, Devise::RpxConnectable::Strategies::RpxConnectable)
