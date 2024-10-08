class User < ApplicationRecord
  has_secure_password
  has_many :resumes, dependent: :destroy
  has_many :covers, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :credit_transactions, dependent: :destroy
  has_many :password_reset_tokens, dependent: :destroy

  validates :email, uniqueness: true
  validates :password, presence: true, length: { minimum: 6}
end
