module Resumes
  class Enhance < ActiveInteraction::Base
    object :enhanced_resume
    array :messages, default: []
    object :output, default: nil

    def execute
      add_messages
      fetch_ai_output

      if errors.any?  # houston we have a problem so stop
        enhanced_resume.fail! if enhanced_resume.may_fail?
        return
      else
        use_credit
      end

      send_notification
    end

    private
    def fetch_ai_output
      output = ChatGpt::Client.run(messages: messages, loggable: enhanced_resume)
      unless output.valid?
        errors.add(:enhanced_resume, output.errors.full_messages.join(", "))
        return
      end

      enhanced_resume.update(content: output.result.summary)
      unless enhanced_resume.may_complete?
        errors.add(:enhanced_resume, 'Resume could not be worked')
        return
      end

      enhanced_resume.complete!
    end

    def send_notification
      if errors.any?
        ConversationChannel.broadcast_to(user.id, { content: errors, type: 'resumes.update_all' })
      else
        ConversationChannel.broadcast_to(user.id, { content: "We finished your resume", type: 'resumes.update_all' })
      end
    end

    def add_messages
      messages << {role: :system, content: system_prompt}
      messages << {role: :user, content: "RESUME: #{enhanced_resume.resume.content}"}
    end

    def system_prompt
      SYSTEM_PROMPT
    end

    def user
      enhanced_resume.resume.user
    end
    def use_credit
      user.decrement!(:credits)
      user.credit_transactions.create!(amount: -1, description: "Used 1 credit to enhance resume", transactionable: enhanced_resume, transaction_type: "debit")
    end

    SYSTEM_PROMPT = "
        As an experienced career advisor, your expertise lies in transforming resumes into standout professional profiles.
        A user will be seeking your assistance to refine their resume so that it impressively showcases their skills and
        experiences. Once the user provides their current resume, your task is to thoughtfully enhance and return the
        revised version, ensuring it adheres to the best industry standards and practices. Please focus solely on delivering
        the polished resume."
  end
end
