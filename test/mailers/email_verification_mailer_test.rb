require "test_helper"

class EmailVerificationMailerTest < ActionMailer::TestCase
  def setup
    @user = Fabricate(:user)
    @token = SecureRandom.hex(10)
  end

  test "send_verification_email" do
    email = EmailVerificationMailer.send_verification_email(@user.id, @token)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['info@jobscraftsman.com'], email.from
    assert_equal [@user.email], email.to
    assert_equal 'Email Verification Instructions', email.subject
    assert_includes email.body.to_s, @token
  end

  test "includes verification link in email body" do
    original_frontend_url = ENV['FRONTEND_URL']

    begin
      ENV['FRONTEND_URL'] = 'http://example.com'
      email = EmailVerificationMailer.send_verification_email(@user.id, @token)

      assert_includes email.body.to_s, "http://example.com/users/verify_email?token=#{@token}"
    ensure
      ENV['FRONTEND_URL'] = original_frontend_url
    end
  end
end