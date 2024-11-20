class Api::V1::MeController < ApplicationController
  include JwtMethods

  def index
    render json: current_user, status: :ok
  end

  def send_verification_email
    result = Tokens::Generate.run(email: current_user.email, kind: 'email_verification_token')
    if result.valid?
      render(json: {message: 'We sent you a verification email, please check your email address'}, status: :ok) and return
    else
      render json: { error: result.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end
end