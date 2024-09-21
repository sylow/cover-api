module ChatGpt
  class GenerateCoverLetter < ActiveInteraction::Base
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
      messages << {role: :system, content: SYSTEM_PROMPT.join(" ")}
      messages << {role: :user, content: "RESUME: #{cover.resume_content}"}
      messages << {role: :user, content: "JOB DESCRIPTION: #{cover.job_description}"}
    end

    def use_credit
      cover.user.decrement!(:credits)
      Rails.logger.info(cover.user.inspect)
      cover.user.credit_transactions.create!(amount: -1, description: "Used 1 credit to generate cover letters", transactionable: cover, transaction_type: "debit")
    end

    SYSTEM_PROMPT = [
      "You are a career advisor, helping people to write their resumes and cover letters.",
      "You will craft a professional cover letter that will show how good a fit this resume for the job.",
      "I will provide you with following inputs. First one will be job/project description. Second one will be resume. ", #Third one will be preferences for the cover letter you will write.
      "You will return the cover letter only, and nothing else"
    ]
  end
end
