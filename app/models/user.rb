# == Schema Information
#
# Table name: users
#
#  confirmation_sent_at :datetime
#  credits              :integer          default(0)
#  email                :string
#  email_confirmed      :boolean          default(FALSE), not null
#  password_digest      :string
#
class User < ApplicationRecord
  has_secure_password
  has_many :resumes, dependent: :destroy
  has_many :covers, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :credit_transactions, dependent: :destroy
  has_many :user_tokens, dependent: :destroy
  has_many :password_reset_tokens, -> { where(kind: :password_reset_token)}, class_name: 'UserToken', dependent: :destroy
  has_many :email_verification_tokens, -> { where(kind: :email_verification_token)}, class_name: 'UserToken', dependent: :destroy

  validates :email, presence: true, email: true, uniqueness: { case_sensitive: false}
  validates :password, presence: true, length: { minimum: 8}

  scope :unconfirmed, -> { where(email_confirmed: false) }
  scope :confirmed, -> { where(email_confirmed: true) }
end
