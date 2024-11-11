# == Schema Information
#
# Table name: purchases
#
#  status     :string
#  package_id :bigint           not null, indexed
#  user_id    :bigint           not null, indexed
#
# Indexes
#
#  index_purchases_on_package_id  (package_id)
#  index_purchases_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (package_id => packages.id)
#  fk_rails_...  (user_id => users.id)
#
class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :package
  has_many :credit_transactions, as: :transactionable
end
