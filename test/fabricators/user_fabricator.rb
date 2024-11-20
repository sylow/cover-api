# test/fabricators/user_fabricator.rb
Fabricator(:user) do
  email { sequence(:email) { |i| "user#{i}@example.com" } }
  password { "password123" }
  email_confirmed { false }
  credits { 0 }
end

Fabricator(:verified_user, from: :user) do
  email_confirmed { true }
end

Fabricator(:unverified_user, from: :user) do
  email_confirmed { false }
end