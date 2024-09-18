module Covers
  class Run < ActiveInteraction::Base
    object :cover
    boolean :enable_notifications, default: true  # set false if we are running it in console

    def execute
      begin
        cover.run!

        run_job
       rescue AASM::InvalidTransition => e
        errors.add(:cover, cover.errors.empty? ? e.message : cover.errors.full_messages.join(", "))
       end
      send_notification
    end

    private
    def run_job
      GenerateCoverJob.perform_later(cover.id)
    end

    def send_notification
      return unless enable_notifications

      ConversationChannel.broadcast_to(cover.user.id, { content: "We are working on your cover letter now", type: 'covers.update_all' })
    end
  end
end


