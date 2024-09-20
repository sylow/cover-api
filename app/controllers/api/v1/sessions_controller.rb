class Api::V1::SessionsController < ApplicationController
  # CSRF not required for API calls, apply null_session to them to override the exception from ApplicationController
  protect_from_forgery with: :null_session

  def create
    user = User.find_by(email: params[:email])
    unless user&.authenticate(params[:password])
      render(json: { error: "We can't find this email and password combination" }, status: :unauthorized) and return
    end

    token = JsonWebToken.encode(user_id: user.id)
    time = Time.now + 72.hours.to_i
    render json: { token: token,
                   exp: time.strftime("%m-%d-%Y %H:%M"),
                   email: user.email,
                   id: user.id }, status: :ok
  end

  def refresh
    token = params[:token]
    data = JWT.decode(token, nil, false).first
    if user = User.find_by(id: data["user_id"])
      decoded = JWT.decode(token, nil, false).first.merge({ "token" => token, "email": user.email, "id" => user.id, "exp" => Time.at(data["exp"]).to_datetime.strftime("%m-%d-%Y %H:%M") })
      render json: decoded, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end
end