require "test_helper"

module Api
  module V1
    class UsersControllerTest < ActionController::TestCase
      def setup
        @request.headers['Content-Type'] = 'application/json'
      end

      test "should verify email with valid token" do
        Fabricate(:email_verification_package)
        user = Fabricate(:user)
        token = Fabricate(:user_token, user: user, kind: 'email_verification_token')

        post :verify_email, params: { token: token.token }
        
        assert_response :success
        assert_equal 'Email verified', json_response['message']
      end

      test "should create new user" do
        post :create, params: {
          email: 'new@example.com',
          password: 'password123'
        }

        assert_response :success
        assert_not_nil json_response['token']
        assert_equal 'new@example.com', json_response['email']
      end

      test "should validate user creation params" do
        post :create, params: {
          email: 'invalid-email',
          password: 'short'
        }

        assert_response :unprocessable_entity
      end
    end
  end
end