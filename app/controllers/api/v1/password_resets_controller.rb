class Api::V1::PasswordResetsController < ApplicationController
  # POST /api/v1/password_resets
  def create
    user = User.find_by(email: params[:email])
    if user
      token = Passwords::GenerateToken.run(user: user).result
      # Ideally, you would trigger an email service here
      PasswordResetMailer.with(user: user, token: token).reset_email.deliver_later
    end
    # We always say okey
    render json: { message: 'Password reset instructions have been sent to your email if email is in our database.' }, status: :ok
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
    password_reset_token = PasswordResetToken.find_by(token: params[:token])

    if password_reset_token&.is_valid?
      user = password_reset_token.user
      if user.update(password: params[:password])
        password_reset_token.destroy # Invalidate the token
        render json: { message: 'Password has been successfully reset' }, status: :ok
      else
        render json: { error: 'Failed to update password', details: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Token is invalid or expired' }, status: :unprocessable_entity
    end
  end
end
