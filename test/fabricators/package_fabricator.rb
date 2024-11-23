Fabricator(:package) do
  name { 'a package' }
  credits { 10 }
  price_cents { 1000 }
end

Fabricator(:email_verification_package, from: :package) do
  name { 'Email Verification' }
  credits { 2 }
  price_cents { 0}
end