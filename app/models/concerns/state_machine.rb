# app/models/concerns/state_machine.rb
module StateMachine
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm do
      state :created, initial: true
      state :running
      state :completed
      state :failed

      event :run do
        transitions from: :created, to: :running, guard: :has_credits?
      end

      event :fail do
        transitions from: :running, to: :failed
      end

      event :complete do
        transitions from: :running, to: :completed
      end
    end
  end

  def has_credits?
    return true if user.credits > 0

    errors.add(:base, "not enough credits to complete the payment")
    false
  end
end