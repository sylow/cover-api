class Cover < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :resume
  has_one :credit_transaction, as: :transactionable

  # Validations
  validates :job_description, presence: true, length: { minimum: 5 }

  # State Machine
  include AASM
  aasm do
    state :created, initial: true
    state :paid
    state :running
    state :completed
    state :failed

    event :pay do
      transitions from: :created, to: :paid, guard: :has_credits?
    end

    event :run do
      transitions from: :paid, to: :running #, before_enter: :run_job
    end

    event :fail do
      transitions from: :running, to: :failed
    end

    event :complete do
      transitions from: :running, to: :completed
    end
  end

  def has_credits?
    user.credits > 0
  end

  def run_job
    if cover.cover.present?
      errors.add(:cover, 'has already been run')
    end

    console.log('Running job')
  end
end
