Stripe.api_key             = ENV['STRIPE_SECRET_KEY']     # e.g. sk_live_...
StripeEvent.signing_secret = ENV['STRIPE_SIGNING_SECRET'] # e.g. whsec_...

class CheckoutCompleted
  def call(event)
    object = event.data.object
    # raise "#{object.client_reference_id} - #{object.amount_subtotal}".inspect
    Purchases::Paid.run!(id: Integer(object.client_reference_id), price_cents: Integer(object.amount_subtotal))
  end
end

StripeEvent.configure do |events|
  events.subscribe 'checkout.session.completed', CheckoutCompleted.new
end