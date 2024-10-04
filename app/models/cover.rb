class Cover < ApplicationRecord
  include StateMachine
  before_create :set_resume_content

  # Associations
  belongs_to :user
  belongs_to :resume
  has_one :credit_transaction, as: :transactionable
  has_many :chat_logs, as: :loggable

  # Validations
  validates :job_description, presence: true, length: { minimum: 5 }

  def set_resume_content
    self.resume_content = resume.content
  end
end
