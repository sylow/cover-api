module Passwords
  class Reset < ActiveInteraction::Base
    string :token
    string :password

    validates :password, presence: true, length: { minimum: 8 }

    def execute
      password_reset_token = find_password_reset_token
      Rails.logger.info token.inspect
      Rails.logger.info password.inspect
      Rails.logger.info password_reset_token.inspect
      Rails.logger.info  password_reset_token&.is_valid?
      if password_reset_token && password_reset_token.is_valid?
        user = password_reset_token.user
        if user.update(password: password)
          # password_reset_token.destroy # Invalidate the token after successful reset
          return { message: 'Password has been successfully reset' }
        else
          errors.add(:base, 'Failed to update password')
          errors.merge!(user.errors) # Add user validation errors to interaction errors
          nil
        end
      else
        errors.add(:base, 'Token is invalid or expired')
        nil
      end
    end

    private

    def find_password_reset_token
      UserToken.find_by(token: token, kind: 'password_reset_token')
    end
  end
end
