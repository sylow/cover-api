class Api::V1::PasswordResetsController < ApplicationController
  def create
    result = Passwords::GenerateToken.run(email: params[:email], kind: 'password_reset') # Replace `current_user` with your user instance as appropriate

    if result.valid?
      render json: { message: 'Password reset instructions have been sent to your email if email is in our database.' }, status: :ok
    else
      render json: { error: result.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/password_resets/:token
  def show
    password_reset_token = PasswordResetToken.find_by(token: params[:token])

    if password_reset_token&.is_valid?
      render json: { message: 'Token is valid' }, status: :ok
    else
      render json: { error: 'Token is invalid or expired' }, status: :unprocessable_entity
    end
  end

  # PUT /api/v1/password_resets/:token
  def update
    result = Passwords::Reset.run(token: params[:token], password: params[:password])
    if result.valid?
      render(json: result.result, status: :ok) and return
    else
      render json: { error: result.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end
end
