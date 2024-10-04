module Resumes
  class Run < ActiveInteraction::Base
    object :resume
    string :kind, default: 'enhance'
    boolean :enable_notifications, default: true  # set false if we are running it in console

    def execute
      begin
        enhanced_resume = resume.enhanced_resumes.build(kind: kind)

        enhanced_resume.run!

        run_job(enhanced_resume)
       rescue AASM::InvalidTransition => e
        errors.add(:resume, resume.errors.empty? ? e.message : resume.errors.full_messages.join(", "))
       end
      send_notification
    end

    private
    def run_job(enhanced_resume)
      EnhanceResumeJob.perform_later(enhanced_resume.id)
    end

    def send_notification
      return unless enable_notifications

      ConversationChannel.broadcast_to(resume.user.id, { content: "We are working on your resume now", type: 'resumes.update_all' })
    end
  end
end


