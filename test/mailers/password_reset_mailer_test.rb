require 'test_helper'

class PasswordResetMailerTest < ActionMailer::TestCase
  def setup
    @user = Fabricate(:user)
    @token = SecureRandom.hex(10)
    @default_from = "info@jobcraftsman.com"
    @frontend_url = "http://example.com"
    ENV['FRONTEND_URL'] = @frontend_url
  end

  def teardown
    ENV.delete('FRONTEND_URL')
    ENV.delete('DEFAULT_FROM_EMAIL')
  end

  test "sends reset email with correct headers" do
    email = PasswordResetMailer.reset_email(@user.id, @token)

    # Basic headers
    assert_equal [@default_from], email.from
    assert_equal [@user.email], email.to
    assert_equal 'Password Reset Instructions', email.subject

    # Verify it can be delivered
    assert_emails 1 do
      email.deliver_now
    end
  end

  test "reset email includes correct reset URL" do
    email = PasswordResetMailer.reset_email(@user.id, @token)

    expected_url = "#{@frontend_url}/sessions/password_reset?token=#{@token}"
    assert_includes email.body.to_s, expected_url
  end

end