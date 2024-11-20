module Purchases
  class Paid < ActiveInteraction::Base
    integer :id
    integer :price_cents

    boolean :enable_notifications, default: true


    def execute
      return errors.add(:user, 'not found') unless user = User.find_by(id: id)

      package = Package.find_by(price_cents: price_cents)

      user.credit_transactions.create!(amount: package.credits, description: 'Token purchase', transactionable: package, transaction_type: 'purchase')
      user.increment!(:credits, package.credits)

      send_notification(user) if enable_notifications

      user
    end

    private
    def send_notification(user)
      ConversationChannel.broadcast_to(user.id, { content: 'Your credits has arrived', type: 'user.update' })
    end
  end
end


