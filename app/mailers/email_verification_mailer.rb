class EmailVerificationMailer < ApplicationMailer
  def send_verification_email(user_id, token)
    @user = User.find(user_id)

    @link = link(token)

    mail(to: @user.email, subject: 'Email Verification Instructions')
  end

  private
  def link(token)
    "#{ENV['FRONTEND_URL']}/users/verify_email?token=#{token}"
  end
end
