module Covers
  class Generate < ActiveInteraction::Base
    object :cover
    array :messages, default: []
    object :output, default: nil

    def execute
      add_messages
      fetch_ai_output

      if errors.any?  # houston we have a problem so stop
        cover.fail! if cover.may_fail?
        return
      else
        use_credit
      end

      send_notification
    end

    private
    def fetch_ai_output
      output = ChatGpt::Client.run(messages: messages, loggable: cover)
      unless output.valid?
        errors.add(:cover, output.errors.full_messages.join(", "))
        return
      end

      cover.update_attribute(:cover, output.result.summary)
      unless cover.may_complete?
        errors.add(:cover, 'Cover letter could not be generated')
        return
      end

      cover.complete!
    end

    def send_notification
      if errors.any?
        ConversationChannel.broadcast_to(cover.user.id, { content: errors, type: 'covers.update_all' })
      else
        ConversationChannel.broadcast_to(cover.user.id, { content: "We finished your cover letter", type: 'covers.update_all' })
      end
    end

    def add_messages
      messages << {role: :system, content: system_prompt}
      messages << {role: :user, content: "RESUME: #{cover.resume_content}"}
      messages << {role: :user, content: "JOB DESCRIPTION: #{cover.job_description}"}
    end

    def system_prompt
      preferences = {
        "words" => 500,
        "formality" => "formal",
        "perspective" => "1st person"
      }.merge(cover.preferences)  # This will use the preferences from the cover, with defaults as a fallback

      SYSTEM_PROMPT % preferences.symbolize_keys
    end

    def use_credit
      cover.user.decrement!(:credits)
      cover.user.credit_transactions.create!(amount: -1, description: "Used 1 credit to generate cover letters", transactionable: cover, transaction_type: "debit")
    end

    SYSTEM_PROMPT = <<~PROMPT
      You are a career advisor, helping people to write their resumes and cover letters.
      You will craft a professional cover letter that will show how good a fit this resume is for the job.
      Cover letter will have around %{words} words.
      Tone of the letter will be %{formality}.
      Perspective of the letter will be %{perspective}.
      You will return the cover letter only, and nothing else.
    PROMPT
  end
end
