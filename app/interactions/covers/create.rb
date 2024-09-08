module Covers
  class Create < ActiveInteraction::Base
    object :user
    integer :resume_id
    string :project

    validates :resume_id, :project, presence: true

    def execute
      fetch_resume
      cover = user.covers.new(inputs)

      unless cover.save
        errors.merge!(cover.errors)
      end

      cover
    end

    def fetch_resume
      inputs[:resume] = user.resumes.find(inputs[:resume_id]).resume
    end
  end
end