class Api::V1::SessionsController < ApplicationController
  # CSRF not required for API calls, apply null_session to them to override the exception from ApplicationController
  protect_from_forgery with: :null_session

  def create
    user = User.find_by(email: params[:email])
    unless user&.authenticate(params[:password])
      render(json: { error: 'unauthorized' }, status: :unauthorized) and return
    end

    token = JsonWebToken.encode(user_id: user.id)
    time = Time.now + 72.hours.to_i
    render json: { token: token,
                   exp: time.strftime("%m-%d-%Y %H:%M"),
                   email: user.email }, status: :ok
  end
end