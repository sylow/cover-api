# test/fabricators/user_token_fabricator.rb
Fabricator(:user_token) do
  user
  token { SecureRandom.hex(10) }
  expires_at { 2.hours.from_now }
  kind { 'password_reset_token' }
end

Fabricator(:email_verification_token, from: :user_token) do
  kind { 'email_verification_token' }
end

Fabricator(:expired_token, from: :user_token) do
  expires_at { 5.hours.ago }
end