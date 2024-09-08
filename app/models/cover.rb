class Cover < ApplicationRecord
  belongs_to :user

  include AASM
  aasm do
    state :created, initial: true
    state :running
    state :completed

    event :run do
      transitions from: :created, to: :running
    end

    event :complete do
      transitions from: :running, to: :completed
    end
  end
end
