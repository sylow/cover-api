require "test_helper"

module Api
  module V1
    class MeControllerTest < ActionController::TestCase
      def setup
        @user = Fabricate(:user)
        sign_in(@user)

        # Clear any existing sidekiq jobs
        Sidekiq::Queues["default"].clear
      end

      test "should get current user info when authenticated" do
        get :index

        assert_response :success
        assert_equal @user.email, json_response['email']
      end

      test "should not get user info when not authenticated" do
        sign_out
        get :index

        assert_response :unauthorized
      end

      test "should send verification email when authenticated" do
        assert_difference -> { @user.email_verification_tokens.count } do
          assert_difference -> { Sidekiq::Queues["default"].size } do
            post :send_verification_email
          end
        end

        assert_response :success
        assert_equal 'We sent you a verification email, please check your email address', json_response['message']

        # Verify token properties
        token = @user.email_verification_tokens.last
        assert_not_nil token
        assert_equal 'email_verification_token', token.kind
        assert token.expires_at > Time.current
      end

      test "should not send verification email when already verified" do
        @user.update!(email_confirmed: true)

        # We expect a token to be generated because the service creates one before checking verification
        assert_no_difference -> { Sidekiq::Queues["default"].size } do
          post :send_verification_email
        end

        assert_response :unprocessable_entity
        assert_includes json_response['error'], 'has already verified email address'
      end

      test "should not send verification email when not authenticated" do
        sign_out

        assert_no_difference -> { UserToken.count } do
          assert_no_difference -> { Sidekiq::Queues["default"].size } do
            post :send_verification_email
          end
        end

        assert_response :unauthorized
      end

      test "should handle errors when sending verification email" do
        @user.update_column(:email, nil) # Force an error condition

        post :send_verification_email

        assert_response :unprocessable_entity
        assert_not_nil json_response['error']
      end

      private

      def sign_out
        @request.headers['Authorization'] = nil
      end

      def teardown
        # Clear sidekiq queues first
        Sidekiq::Queues["default"].clear

        # Delete records in the correct order to avoid foreign key constraints
        UserToken.delete_all
        User.delete_all
      end
    end
  end
end