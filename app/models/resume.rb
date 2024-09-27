class Resume < ApplicationRecord
  belongs_to :user
  has_many :covers
  has_many :chat_logs, as: :loggable

  # Validations
  validates :title, presence: true, length: { minimum: 5 }
  validates :content, presence: true, length: { minimum: 500 }
end