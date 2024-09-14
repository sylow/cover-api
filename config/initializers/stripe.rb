Stripe.api_key             = ENV['STRIPE_SECRET_KEY']     # e.g. sk_live_...
StripeEvent.signing_secret = ENV['STRIPE_SIGNING_SECRET'] # e.g. whsec_...

class CheckoutCompleted
  def call(event)
    object = event.data.object
    if user = User.find_by(id: object.client_reference_id)
      user.purchases.create(credits: object.metadata["token_count"], price_cents: object.amount_total)
      ActionCable.server.broadcast "ChatChannel_#{user.id}", {type: 'token', kind: 'token_purchased'}
    end
  end
end

StripeEvent.configure do |events|
  events.subscribe 'checkout.session.completed', CheckoutCompleted.new
end