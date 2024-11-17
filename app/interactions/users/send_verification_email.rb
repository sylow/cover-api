module Users
  class VerifyEmail < ActiveInteraction::Base
    object :token

    def execute
      return errors.add(:token, 'is invalid') unless user_token = UserToken.find_by(token: token, kind: 'email_verification')

      user = user_token.user
      user.update(email_confirmed: true)
      user_token.destroy

      user
    end

    private
    def add_free_package(user)
      free_package = Package.find_by(name: 'Free')
      user.purchases.create(package: free_package, credits: free_package.credits)
    end
  end
end