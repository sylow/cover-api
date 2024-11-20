require "test_helper"

module Api
  module V1
    class PasswordResetsControllerTest < ActionController::TestCase
      test "should initiate password reset for valid email" do
        user = Fabricate(:user)

        post :create, params: { email: user.email }

        assert_response :success
        assert_equal 'Password reset instructions have been sent to your email if email is in our database.', json_response['message']
      end

      test "should return same message for non-existent email to prevent enumeration" do
        post :create, params: { email: 'nonexistent@example.com' }
        
        assert_response :success
        assert_equal 'Password reset instructions have been sent to your email if email is in our database.', json_response['message']
      end

      test "should validate token" do
        password_reset_token = Fabricate(:user_token, kind: 'password_reset_token')
        
        get :show, params: { token: password_reset_token.token }
        
        assert_response :success
        assert_equal 'Token is valid', json_response['message']
      end

      test "should reject invalid token" do
        get :show, params: { token: 'invalid-token' }
        
        assert_response :unprocessable_entity
        assert_equal 'Token is invalid or expired', json_response['error']
      end

      test "should update password with valid token" do
        user = Fabricate(:user)
        token = Fabricate(:user_token, user: user, kind: 'password_reset_token')
        new_password = 'new_valid_password123'

        patch :update, params: { 
          token: token.token,
          password: new_password
        }

        assert_response :success
        assert_equal 'Password has been successfully reset', json_response['message']
      end

      test "should not update password with invalid token" do
        patch :update, params: { 
          token: 'invalid-token',
          password: 'new_password123'
        }

        assert_response :unprocessable_entity
        assert_includes json_response['error'], 'Token is invalid or expired'
      end

      test "should validate password length when updating" do
        token = Fabricate(:user_token, kind: 'password_reset_token')

        patch :update, params: { 
          token: token.token,
          password: 'short'
        }

        assert_response :unprocessable_entity
        assert_includes json_response['error'], 'Password is too short'
      end
    end
  end
end