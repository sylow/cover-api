class Package < ApplicationRecord
  monetize :price_cents
  has_many :credit_transactions, as: :transactionable
end
