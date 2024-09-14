class Api::V1::TransactionsController < ApplicationController
  include JwtMethods

  def index
    render json: current_user.credit_transactions
  end

end