class Cover < ApplicationRecord
  before_create :set_resume_content

  # Associations
  belongs_to :user
  belongs_to :resume
  has_one :credit_transaction, as: :transactionable
  has_many :chat_logs, as: :loggable

  # Validations
  validates :job_description, presence: true, length: { minimum: 5 }

  # State Machine
  include AASM
  aasm do
    state :created, initial: true
    state :running
    state :completed
    state :failed

    event :run do #todo, add a transaction log
      transitions from: :created, to: :running, guard: :has_credits?
    end

    event :fail do
      transitions from: :running, to: :failed
    end

    event :complete do
      transitions from: :running, to: :completed
    end
  end

  def has_credits?
    return true if user.credits > 0

    errors.add(:base, "not enough credits to complete the payment")
    return false
  end

  def set_resume_content
    self.resume_content = resume.content
  end

end
