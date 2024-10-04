class EnhanceResumeJob < ApplicationJob
  # include Sidekiq::Job
  queue_as :default

  def perform(id)
    enhanced_resume = EnhancedResume.find(id)

    # Run your logic for generating the cover
    Resumes::Enhance.run(enhanced_resume: enhanced_resume)

  end
end
