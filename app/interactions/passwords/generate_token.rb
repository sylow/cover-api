module Passwords
  class GenerateToken < ActiveInteraction::Base
    object :user

    def execute
      token = SecureRandom.hex(10)
      user.password_reset_tokens.create(token: token, expires_at: 2.hours.from_now)
      token
    end
  end
end