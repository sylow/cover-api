class EnhancedResume < ApplicationRecord
  include StateMachine

  # Associations
  belongs_to :resume
  has_one :user, through: :resume
  has_one :credit_transaction, as: :transactionable
  has_many :chat_logs, as: :loggable

end
