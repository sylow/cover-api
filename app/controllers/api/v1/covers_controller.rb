class Api::V1::CoversController < ApplicationController
  include JwtMethods

  def index
    render json: current_user.covers.order(created_at: :desc), status: :ok
  end

  def create
    outcome = Covers::Create.run(params[:cover].merge(user: current_user))
    if outcome.valid?
      render json: outcome.result, status: :created
    else
      render json: outcome.errors, status: :unprocessable_entity
    end
  end

  def run
    outcome = Covers::Run.run(cover: current_user.covers.find(params[:cover_id]))
    if outcome.valid?
      render json: outcome.result, status: :ok
    else
      render json: outcome.errors, status: :unprocessable_entity
    end
  end
end