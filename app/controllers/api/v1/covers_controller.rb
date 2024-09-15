class Api::V1::CoversController < ApplicationController
  include JwtMethods

  def index
    render json: current_user.covers
  end

  def create
    outcome = Covers::Create.run(params[:cover].merge(user: current_user))

    if outcome.valid?
      render json: outcome.result, status: :created
    else
      render json: outcome.errors, status: :unprocessable_entity
    end
  end

  def pay
    outcome = Covers::Pay.run(user: current_user, id: params[:cover_id])
    return_result(outcome, :ok)
  end

  private
  def return_result(outcome, status=:ok)
    if outcome.valid?
      render json: outcome.result, status: status
    else
      render json: outcome.errors.full_messages, status: :unprocessable_entity
    end
  end
end