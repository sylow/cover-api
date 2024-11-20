module Tokens
  class Generate < ActiveInteraction::Base
    string :email
    string :kind, in: %w[password_reset_token email_verification_token]

    def execute
      return errors.add(:user, "not found") unless user

      return errors.add(:user, "has already verified email address") if user.email_confirmed && kind == 'email_verification_token'

      token_record = create_token_record
      return errors.add(:user, token_record.errors.full_messages.join(', ')) unless token_record

      delete_previous_tokens(token_record)
      send_token_email(token_record)

      token_record
    end

    private
    def user
      @user ||= User.find_by(email: email)
    end

    def create_token_record
      model.create(token: generate_token, expires_at: 2.hours.from_now)
    end

    def model
      user.user_tokens.where(kind: kind)
    end

    def generate_token
      SecureRandom.hex(10)
    end

    def send_token_email(token_record)
      case kind
      when 'password_reset_token'
        PasswordResetMailer.reset_email(user.id, token_record.token).deliver_later
      when 'email_verification_token'
        EmailVerificationMailer.send_verification_email(user.id, token_record.token).deliver_later
      end
    end

    def delete_previous_tokens(current_token)
      model.where.not(id: current_token.id).delete_all
    end
  end
end