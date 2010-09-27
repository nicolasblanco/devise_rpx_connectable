# encoding: utf-8

module Devise #:nodoc:
  module RpxConnectable #:nodoc:

    # RPX view helpers to easily add the link to the RPX connection popup and also the necessary JS code.
    #
    module Helpers
      
      # Creates the link to the RPX connection popup.
      # If you create a link without putting the JS code, the popup will load in a new page.
      # By default the RPX link will be linked to the RPX application name you defined in the configuration.
      # It may be overriden using :application_name if the options.
      # The second parameter is the return URL, it must be absolute (***_url).
      #
      # For example :
      # <%= link_to_rpx "Signin using RPX!", user_session_url %>
      #
      def link_to_rpx(link_text, link_url, options={})
        options = { :unobtrusive => true }.merge(options)
    		token_url = build_token_url(link_url)
    		RPXNow.popup_code(link_text, rpx_application_name_from_options(options), token_url, options).html_safe
      end

      # Embeds the RPX connection iframe in your page.
      # By default the RPX frame will refer to the RPX application name you defined in the configuration.
      # It may be overriden using :application_name if the options.
      # The first parameter is the return URL, it must be absolute (***_url).
      # You can override default iframe size using :width and :height in the options.
      #
      # Example :
      # <%= embed_rpx user_session_url %>
      #
      def embed_rpx(link_url, options={})
        token_url = build_token_url(link_url)
        RPXNow.embed_code(rpx_application_name_from_options(options), token_url, options).html_safe
      end

      # Returns the necessary JS code for the RPX popup.
      # It is recommended to put this code just before the </body> tag of your layout.
      # 
      # For example :
      # ...
      # <%= javascript_include_rpx(user_session_url) %>
      # </body>
      # </html>
      #
      def javascript_include_rpx(link_url, options={})
    		token_url = build_token_url(link_url)
        RPXNow.popup_source(rpx_application_name_from_options(options), token_url, options).html_safe
      end

      protected
        def rpx_application_name_from_options(options)
          options[:application_name] ? options.delete(:application_name) : ::Devise.rpx_application_name
        end
        
        def build_token_url(return_url)
          token = return_url.include?("?") ? "&" : "?"
          "#{return_url}#{token}authenticity_token=#{Rack::Utils.escape(form_authenticity_token)}"
        end
      
    end
  end
end

::ActionView::Base.send :include, Devise::RpxConnectable::Helpers
