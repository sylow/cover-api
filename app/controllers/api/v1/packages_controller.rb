class Api::V1::PackagesController < ApplicationController
  def index
    render json: Package.all
  end
end