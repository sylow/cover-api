module Users
  class VerifyEmail < ActiveInteraction::Base
    string :token

    def execute
      return errors.add(:token, 'is invalid') unless tokenRecord = find_valid_token
      return errors.add(:user, 'has already verified email address') if tokenRecord.user.email_confirmed

      verify_email(tokenRecord)
      add_email_verification_credits(tokenRecord)
      destroy_token(tokenRecord)

      tokenRecord.user
    end

    private
    def find_valid_token
      tokenRecord = UserToken.find_by(token: token, kind: 'email_verification_token')
      return tokenRecord if tokenRecord && tokenRecord.valid?
    end

    def verify_email(tokenRecord)
      tokenRecord.user.update_column(:email_confirmed, true)
    end

    def destroy_token(tokenRecord)
      tokenRecord.destroy
    end

    def add_email_verification_credits(tokenRecord)
      # Add credits to user account for verifying email
      package = Package.find_by(price_cents: 0)
      tokenRecord.user.credit_transactions.create!(amount: package.credits, description: 'Token purchase', transactionable: package, transaction_type: 'purchase')
      tokenRecord.user.increment!(:credits, package.credits)
    end
  end
end
