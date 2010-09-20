require 'ruby-debug'
require 'rspec'

module Devise
  class Strategies
    class Base
    end
  end
end

RSpec.configure do |config|
  config.mock_with :rspec
end

