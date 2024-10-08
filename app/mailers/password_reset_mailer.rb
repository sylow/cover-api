class PasswordResetMailer < ApplicationMailer
  def reset_email
    @user = params[:user]
    @token = params[:token]

    @reset_url = "#{ENV['FRONTEND_URL']}/password_resets/#{@token}/edit" # Adjust the URL to match your front-end routes

    mail(to: @user.email, subject: 'Password Reset Instructions')
  end
end
