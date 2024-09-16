module ChatGpt
  class GenerateCoverLetter < ActiveInteraction::Base
    object :cover
    array :messages, default: []

    def execute
      add_system_messages
      add_user_messages

      result = ChatGpt::Client.run(messages: messages, user: cover.user)
    end

    private
    def add_system_messages
      messages << {role: :system, content: SYSTEM_PROMPT.join(" ")}
    end

    def add_user_messages
      messages << {role: :user, content: "RESUME: #{cover.resume}"}
      messages << {role: :user, content: "JOB DESCRIPTION: #{cover.job_description}"}
    end


    SYSTEM_PROMPT = [
      "You are a career advisor, helping people to write their resumes and cover letters.",
      "You will craft a professional cover letter that will show how good a fit this resume for the job.",
      "I will provide you with following inputs. First one will be job/project description. Second one will be resume. ", #Third one will be preferences for the cover letter you will write.
      "You will return as json object with the cover letter, example response {cover:'Here will be cover letter', resume_quality: 0.9, cover_quality: 0.8}"]
  end
end
