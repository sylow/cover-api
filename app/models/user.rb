class User < ApplicationRecord
  has_secure_password
  validates :email, uniqueness: true
  validates :password, presence: true, length: { minimum: 10}
end
