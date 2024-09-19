module Covers
  class Create < ActiveInteraction::Base
    object :user
    integer :resume_id
    string :resume_content, default: -> { user.resumes.find(resume_id).resume }
    string :job_description
    hash :preferences, default: {} do
      string :formality, default: 'formal'
      string :perspective, default: '1st person'
      integer :words, default: 500
    end

    validates :resume_id, :job_description, presence: true

    def execute
      cover = user.covers.new(inputs)

      unless cover.save
        errors.merge!(cover.errors)
      end

      cover
    end
  end
end
