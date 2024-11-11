module Passwords
  class GenerateToken < ActiveInteraction::Base
    string :email
    string :kind, in: %w[password_reset email_confirmation]

    def execute
      token_record = model.create(token: token, expires_at: 2.hours.from_now)

      PasswordResetMailer.reset_email(user.id, token_record.token).deliver_later
    end

    private
    def user
      @user ||= User.find_by(email: email)
    end

    def model
      kind == 'password_reset' ? user.password_reset_tokens : user.email_confirmation_tokens
    end

    def token
      token ||= SecureRandom.hex(10)
    end
  end
end