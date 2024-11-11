# == Schema Information
#
# Table name: packages
#
#  credits     :integer
#  description :string
#  name        :string
#  price_cents :integer
#  stripe_id   :string
#
class Package < ApplicationRecord
  monetize :price_cents
  has_many :credit_transactions, as: :transactionable
end
