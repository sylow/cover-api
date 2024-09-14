class Cover < ApplicationRecord
  belongs_to :user
  has_many :credit_transactions, as: :transactionable

  include AASM
  aasm do
    state :created, initial: true
    state :running
    state :completed

    # We need to add a guard here to ensure
    # that user has enough credits
    event :run do
      transitions from: :created, to: :running
    end

    event :complete do
      transitions from: :running, to: :completed
    end
  end
end
