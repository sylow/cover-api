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
  has_many :password_reset_tokens, -> { where(kind: :password_reset_token)}, class_name: 'UserToken', dependent: :destroy

  validates :email, uniqueness: true
  validates :password, presence: true, length: { minimum: 6}
end
