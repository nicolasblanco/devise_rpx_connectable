require "spec_helper"
require "active_support/all"

require File.join(File.dirname(__FILE__), '..', 'lib', 'devise_rpx_connectable', 'strategy')

class User
  def self.rpx_extended_user_data; true; end
  def self.rpx_additional_user_data; true; end
  def self.request_keys
    @request_keys || {}
  end
  def self.request_keys=(value)
    @request_keys = value
  end
end

class RPXNow
  @@api_key = "abcdefgh"
  cattr_accessor :api_key
end

RPX_USER_DATA = { "identifier" => "superpipo_user", :request_keys => {}}
PARAMS = { :token => "rpx_token" }

describe 'DeviseRpxConnectable' do
  before(:each) do
    @strategy = Devise::RpxConnectable::Strategies::RpxConnectable.new
    @mapping = mock(:mapping)
    @mapping.should_receive(:to).and_return(User)
    @strategy.should_receive(:mapping).and_return(@mapping)
    @strategy.should_receive(:params).and_return(PARAMS)

    @user = User.new
  end

  it "should fail if RPX returns no valid user" do
    RPXNow.should_receive(:user_data).and_return(nil)

    @strategy.should_receive(:"fail!").with(:rpx_invalid).and_return(true)

    lambda { @strategy.authenticate! }.should_not raise_error
  end

  describe 'when the RPX user is valid' do
    before(:each) do
      RPXNow.should_receive(:user_data).and_return(RPX_USER_DATA)
    end

    it "should authenticate if a user exists in database" do
      User.should_receive(:authenticate_with_rpx).with({ :identifier => RPX_USER_DATA["identifier"], :request_keys => {} }).and_return(@user)

      @user.should_receive(:on_before_rpx_success).with(RPX_USER_DATA).and_return(true)

      @strategy.should_receive(:"success!").with(@user).and_return(true)

      lambda { @strategy.authenticate! }.should_not raise_error
    end

    describe 'when no user exists in database' do
      before(:each) do
        User.should_receive(:authenticate_with_rpx).with({ :identifier => RPX_USER_DATA["identifier"], :request_keys => {} }).and_return(nil)
      end

      it "should fail unless rpx_auto_create_account" do
        User.should_receive(:"rpx_auto_create_account?").and_return(false)
        @strategy.should_receive(:"fail!").with(:rpx_invalid).and_return(true)

        lambda { @strategy.authenticate! }.should_not raise_error
      end

      it "should create a new user and success if rpx_auto_create_account" do
        User.should_receive(:"rpx_auto_create_account?").and_return(true)

        User.should_receive(:new).and_return(@user)
        @user.should_receive(:"store_rpx_credentials!").with(RPX_USER_DATA).and_return(true)
        @user.should_receive(:on_before_rpx_auto_create).with(RPX_USER_DATA).and_return(true)
        @user.should_receive(:save).with({ :validate => false }).and_return(true)
        @user.should_receive(:on_before_rpx_success).with(RPX_USER_DATA).and_return(true)

        @strategy.should_receive(:"success!").with(@user).and_return(true)

        lambda { @strategy.authenticate! }.should_not raise_error
      end
    end
  end
end

