# == Schema Information
#
# Table name: user_tokens
#
#  expires_at :datetime         not null
#  kind       :string           default("password_reset_token"), not null
#  token      :string           not null, indexed
#  user_id    :bigint           not null, indexed
#
# Indexes
#
#  index_user_tokens_on_token    (token) UNIQUE
#  index_user_tokens_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class UserToken < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :token, presence: true, uniqueness: true
  validates :kind, presence: true, inclusion: { in: %w(password_reset_token email_verification_token) }
  validates :expires_at, presence: true

  # Scopes
  scope :valid, -> { where("expires_at >= ?", Time.now) }

  # Check if the token is still valid
  def is_valid?
    expires_at >= Time.now
  end
end
