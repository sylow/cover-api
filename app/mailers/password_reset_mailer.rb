class PasswordResetMailer < ApplicationMailer
  def reset_email(user_id, token)
    @user = User.find(user_id)

    @reset_url = reset_url(token)

    mail(to: @user.email, subject: 'Password Reset Instructions')
  end

  private
  def reset_url(token)
    "#{ENV['FRONTEND_URL']}/sessions/password_reset?token=#{token}" # Adjust the URL to match your front-end routes
  end
end
