class Api::V1::ResumesController < ApplicationController
  include JwtMethods

  def index
    render json: current_user.resumes
  end

  def create
    outcome = Resumes::Create.run(params[:resume].merge(user: current_user))

    if outcome.valid?
      render json: outcome.result, status: :created
    else
      render json: outcome.errors.full_messages, status: :unprocessable_entity
    end
  end

  def enhance
    outcome = Resumes::Run.run(resume: current_user.resumes.find(params[:resume_id]), kind: 'enhance')
    if outcome.valid?
      render json: outcome.result, status: :ok
    else
      render json: outcome.errors, status: :unprocessable_entity
    end
  end
end