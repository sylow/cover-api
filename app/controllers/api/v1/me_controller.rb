class Api::V1::MeController < ApplicationController
  include JwtMethods

  def index
    render json: current_user, status: :ok
  end
end