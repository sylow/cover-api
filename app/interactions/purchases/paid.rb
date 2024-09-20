module Purchases
  class Paid < ActiveInteraction::Base
    integer :id
    integer :price_cents

    boolean :enable_notifications, default: true


    def execute
      user = User.find_by(id: id)
      package = Package.find_by(price_cents: price_cents)
      return errors.add(:email, 'User not found') if user.blank?

      user.credit_transactions.create!(amount: package.credits, description: 'Token purchase', transactionable: package, transaction_type: 'purchase')
      user.increment!(:credits, package.credits)
      send_notification(user)
    end

    private
    def send_notification(user)
      return unless enable_notifications
      ConversationChannel.broadcast_to(user.id, { content: 'Your credits has arrived', type: 'user.update' })
    end
  end
end


