class Api::V1::UsersController < ApplicationController
  # CSRF not required for API calls, apply null_session to them to override the exception from ApplicationController
  protect_from_forgery with: :null_session

  def create
    user = User.create(email: params[:email], password: params[:password])
    unless user.valid?
      render(json:  user.errors.full_messages.join("\n") , status: :unprocessable_entity) and return
    end

    token = JsonWebToken.encode(user_id: user.id)
    time = Time.now + 72.hours.to_i
    render json: { token: token,
                   exp: time.strftime("%m-%d-%Y %H:%M"),
                   email: user.email }, status: :ok
  end


  def verify_email
    result = Users::VerifyEmail.run(token: params[:token])
    if result.valid?
      render json: { message: 'Email verified' }, status: :ok
    else
      render json: { message: result.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def forgot
    head :ok
  end

end