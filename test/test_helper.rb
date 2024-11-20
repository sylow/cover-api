# test/test_helper.rb
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/autorun"
require "fabrication"
require 'sidekiq/testing'
Sidekiq::Testing.fake!  # This puts Sidekiq into fake mode

Dir[Rails.root.join('test', 'support', '**', '*.rb')].sort.each { |f| require f }


module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    setup do
      Sidekiq::Queues.clear_all  # Clear any queued jobs before each test
    end
    # Add more helper methods to be used by all tests here...
  end
end

# Add support for JSON response parsing
module ActionDispatch
  class IntegrationTest
    def json_response
      JSON.parse(response.body)
    end
  end
end

# Add support for authentication in controller tests
module ActionController
  class TestCase
    def auth_headers(user)
      token = JsonWebToken.encode(user_id: user.id)
      { 'Authorization' => "Bearer #{token}" }
    end
  end
end

class ActionDispatch::IntegrationTest
  def sign_in_as(user)
    token = JsonWebToken.encode(user_id: user.id)
    token
  end
end

class ActionController::TestCase
  include ControllerTestHelpers
end