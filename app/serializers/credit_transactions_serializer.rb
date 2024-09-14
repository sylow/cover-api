class CreditTransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :transaction_kind, :description, :created_at

  def created_at
    object.created_at.strftime('%B %d, %Y %H:%M')
  end
end