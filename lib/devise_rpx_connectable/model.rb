# encoding: utf-8

module Devise #:nodoc:
  # module RpxConnectable #:nodoc:
  module Models #:nodoc:

    # RPX Connectable Module, responsible for validating authenticity of a
    # user and storing credentials while signing in.
    #
    # == Configuration:
    #
    # You can overwrite configuration values by setting in globally in Devise (+Devise.setup+),
    # using devise method, or overwriting the respective instance method.
    #
    # +rpx_identifier_field+ - Defines the name of the RPX identifier database attribute/column.
    #
    # +rpx_auto_create_account+ - Speifies if account should automatically be created upon connect
    #                                 if not already exists.
    #
    # == Examples:
    #
    #    User.authenticate_with_rpx(:identifier => 'john@doe.com')     # returns authenticated user or nil
    #    User.find(1).rpx_connected?                                  # returns true/false
    #
    module RpxConnectable

      def self.included(base) #:nodoc:
        base.class_eval do
          extend ClassMethods
        end
      end

      # Store RPX account/session credentials.
      #
      def store_rpx_credentials!(attributes = {})
        # Confirm without e-mail - if confirmable module is loaded.
        self.skip_confirmation! if self.respond_to?(:skip_confirmation!)

        # Only populate +email+ field if it's available (e.g. if +authenticable+ module is used).
        self.email = attributes[:email] || '' if self.respond_to?(:email)

        # Lazy hack: These database fields are required if +authenticable+/+confirmable+
        # module(s) is used. Could be avoided with :null => true for authenticatable
        # migration, but keeping this to avoid unnecessary problems.
        self.password_salt = '' if self.respond_to?(:password_salt)
        self.encrypted_password = '' if self.respond_to?(:encrypted_password)
      end

      # Checks if RPX connected.
      #
      def rpx_connected?
        self.send(:"#{self.class.rpx_identifier_field}").present?
      end
      alias :is_rpx_connected? :rpx_connected?

      # Hook that gets called before a successful connection (each time).
      # Useful for fetching additional user info (etc.) from RPX.
      #
      # Default: Do nothing.
      #
      # == Example:
      #
      #   # Overridden in RPX connectable model, e.g. "User".
      #   #
      #   def before_rpx_success(rpx_user)
      #
      #      # Get email (if the provider supports it)
      #      email = rpx_user["email"]
      #     # etc...
      #
      #   end
      #
      # == For more info:
      #
      #   * http://github.com/grosser/rpx_now
      #
      def on_before_rpx_success(rpx_user)
        self.send(:before_rpx_success, rpx_user) if self.respond_to?(:before_rpx_success)
      end
      
      # Hook that gets called before the auto creation of the user.
      # Therefore, this hook is only called when rpx_auto_create_account config option is enabled.
      # Useful for fetching additional user info (etc.) from RPX.
      #
      # Default: Do nothing.
      #
      # == Example:
      #
      #   # Overridden in RPX connectable model, e.g. "User".
      #   #
      #   def before_rpx_auto_create(rpx_user)
      #
      #      # Get email (if the provider supports it)
      #      email = rpx_user["email"]
      #     # etc...
      #
      #   end
      #
      # == For more info:
      #
      #   * http://github.com/grosser/rpx_now
      #
      def on_before_rpx_auto_create(rpx_user)
        self.send(:before_rpx_auto_create, rpx_user) if self.respond_to?(:before_rpx_auto_create)
      end

      module ClassMethods

        # Configuration params accessible within +Devise.setup+ procedure (in initalizer).
        #
        # == Example:
        #
        #   Devise.setup do |config|
        #     config.rpx_identifier_field = :rpx_identifier
        #     config.rpx_auto_create_account = true
        #     config.get_extended_user_data = true
        #   end
        #
        ::Devise::Models.config(self,
          :rpx_identifier_field,
          :rpx_auto_create_account,
          :rpx_extended_user_data,
          :rpx_additional_user_data
        )

        # Alias don't work for some reason, so...a more Ruby-ish alias
        # for +rpx_auto_create_account+.
        #
        def rpx_auto_create_account?
          self.rpx_auto_create_account
        end

        # Authenticate a user based on RPX Identifier.
        #
        def authenticate_with_rpx(attributes = {})
          begin
            if attributes[:identifier].present?
              user = self.find_for_rpx(attributes[:identifier])
            end
              
            if !user and attributes[:email]
              if user = self.find_by_email(attributes[:email])
				user.identities.new(:identifier => attributes[:identifier]) #build_identity?
				user.save!
			  end
            end
            
            return user
            
          rescue
            raise StandardError, "Error in authenticate_with_rpx() -> #{$!}"
          end
        end

        protected

        # Find first record based on conditions given (RPX identifier).
        # Overwrite to add customized conditions, create a join, or maybe use a
        # namedscope to filter records while authenticating.
        #
        def find_for_rpx(identifier)
          #self.first(:conditions =>  { rpx_identifier_field => identifier })
		  @identity = Identity.first(:conditions => ["identifier = ?", identifier])
		  if @identity
		    return self.find @identity.user_id
		  end
		  return false
        end

        # Contains the logic used in authentication. Overwritten by other devise modules.
        # In the RPX connect case; nothing fancy required.
        #
        def valid_for_rpx(resource, attributes)
          true
        end

      end

    end
  end
end
