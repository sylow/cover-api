class PasswordResetToken < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :token, presence: true, uniqueness: true
  validates :expires_at, presence: true

  # Scopes
  scope :valid, -> { where("expires_at >= ?", Time.now) }

  # Check if the token is still valid
  def is_valid?
    expires_at >= Time.now
  end
end
