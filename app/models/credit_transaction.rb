class CreditTransaction < ApplicationRecord
  belongs_to :user
  belongs_to :transactionable, polymorphic: true
end
