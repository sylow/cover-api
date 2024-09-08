module Resumes
  class Create < ActiveInteraction::Base
    object :user
    string :title, :resume

    validates :title, :resume, presence: true

    def execute
      record = user.resumes.new(inputs)

      unless record.save
        errors.merge!(record.errors)
      end

      record
    end
  end
end