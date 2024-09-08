class User < ApplicationRecord
  has_secure_password
  has_many :resumes
  has_many :covers

  validates :email, uniqueness: true
  validates :password, presence: true, length: { minimum: 6}
end
