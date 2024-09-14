class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :package
  has_many :credit_transactions, as: :transactionable
end
