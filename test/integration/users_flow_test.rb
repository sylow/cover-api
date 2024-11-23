require "test_helper"

class UsersFlowTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  def setup
    @user = Fabricate(:user)
  end

  def auth_headers(user)
    token = JsonWebToken.encode(user_id: user.id)
    {
      'Authorization' => "Bearer #{token}",
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  end

  test "complete email verification flow" do
    Fabricate(:email_verification_package)
    # Step 1: Request verification email
    assert_enqueued_with(job: ActionMailer::MailDeliveryJob) do
      post "/api/v1/me/send_verification_email",
        headers: auth_headers(@user)

      assert_response :success
      assert_equal 'We sent you a verification email, please check your email address', json_response['message']
    end
    
    # Extract token from email verification tokens
    token = @user.email_verification_tokens.last.token
    
    # Step 2: Verify email with token
    post "/api/v1/users/verify_email",
      params: { token: token }
    
    assert_response :success
    assert_equal 'Email verified', json_response['message']
    assert @user.reload.email_confirmed
  end

  test "complete password reset flow" do
    @user.update!(email_confirmed: true)

    # Step 1: Request password reset
    assert_enqueued_with(job: ActionMailer::MailDeliveryJob) do
      post "/api/v1/password_resets",
        params: { email: @user.email }

      assert_response :success
      assert_equal 'Password reset instructions have been sent to your email if email is in our database.', json_response['message']
    end
    
    # Extract token from password reset tokens
    token = @user.user_tokens.find_by(kind: 'password_reset_token').token
    new_password = 'new_secure_password123'
    
    # Step 2: Reset password with token
    put "/api/v1/password_resets/#{token}",
      params: { password: new_password }
    
    assert_response :success
    assert_equal 'Password has been successfully reset', json_response['message']
    
    # Verify new password works
    assert @user.reload.authenticate(new_password)
    
    # Verify token was consumed
    assert_nil @user.user_tokens.find_by(kind: 'password_reset_token', token: token)
  end

  test "rate limiting on verification email requests" do
    skip "Rate limiting not implemented in current codebase"
    3.times do
      post "/api/v1/me/send_verification_email",
        headers: auth_headers(@user)
      assert_response :success
    end

    # Fourth attempt should be rate limited
    post "/api/v1/me/send_verification_email",
      headers: auth_headers(@user)
    assert_response :too_many_requests
  end

  test "rate limiting on password reset requests" do
    skip "Rate limiting not implemented in current codebase"
    @user.update!(email_confirmed: true)

    3.times do
      post "/api/v1/password_resets",
        params: { email: @user.email }
      assert_response :success
    end

    # Fourth attempt should be rate limited
    post "/api/v1/password_resets",
      params: { email: @user.email }
    assert_response :too_many_requests
  end

  test "security implications of concurrent password reset tokens" do
    @user.update!(email_confirmed: true)

    # Request first password reset
    assert_enqueued_with(job: ActionMailer::MailDeliveryJob) do
      post "/api/v1/password_resets",
        params: { email: @user.email }
    end
    first_token = @user.user_tokens.find_by(kind: 'password_reset_token').token

    # Request second password reset - should invalidate first token
    assert_enqueued_with(job: ActionMailer::MailDeliveryJob) do
      post "/api/v1/password_resets",
        params: { email: @user.email }
    end
    a = @user.user_tokens.find_by(kind: 'password_reset_token')
    second_token = @user.user_tokens.find_by(kind: 'password_reset_token').token

    # Try to use first token (should fail as it was invalidated)
    put "/api/v1/password_resets/#{first_token}",
      params: { password: 'new_password123' }
    assert_response :unprocessable_entity
    assert_equal 'Token is invalid or expired', json_response['error']

    # Use second (latest) token (should succeed)
    put "/api/v1/password_resets/#{second_token}",
      params: { password: 'new_password1234' }
    assert_response :success
    assert_equal 'Password has been successfully reset', json_response['message']
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end