# == Schema Information
#
# Table name: credit_transactions
#
#  amount               :integer          not null
#  description          :string           not null
#  transaction_type     :string           not null
#  transactionable_type :string           not null, indexed => [transactionable_id]
#  transactionable_id   :bigint           not null, indexed => [transactionable_type]
#  user_id              :bigint           not null, indexed
#
# Indexes
#
#  index_credit_transactions_on_transactionable  (transactionable_type,transactionable_id)
#  index_credit_transactions_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class CreditTransaction < ApplicationRecord
  belongs_to :user
  belongs_to :transactionable, polymorphic: true
end
