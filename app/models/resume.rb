class Resume < ApplicationRecord
  belongs_to :user
  has_many :covers
  has_many :enhanced_resumes
  has_many :chat_logs, as: :loggable
  has_one :enhanced_resume, -> { where(kind: 'enhance') }, class_name: 'EnhancedResume'

  # Validations
  validates :title, presence: true, length: { minimum: 5 }
  validates :content, presence: true, length: { minimum: 500 }
end