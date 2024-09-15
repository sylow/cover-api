module ChatGpt
  class GenerateCoverLetter < ActiveInteraction::Base
    object :cover

    attributes :messages
    def execute
      add_system_messages
      add_user_messages

      result = ChatGpt::Client.run(messages: messages)
    end

    private
    def add_system_messages
      messages << {role: :system, content: SYSTEM_PROMPT.join(" ")}
    end

    def add_user_messages
      add_message(role: :system, content: "RESUME: #{cover.resume}")
      add_message(role: :system, content: "JOB DESCRIPTION: #{cover.job_description}")
    end

    def add_message(role:, content:)
      service.add({role: role, content: content})
    end

    SYSTEM_PROMPT = [
      'You are a career advisor, helping people to write their resumes and cover letters.',
      'You will craft a professional cover letter that will show how good a fit this resume for the job.',
      'I will provide you with 3 input. First one will be job/project description. Second one will be resume. Third one will be preferences for the cover letter you will write.',
      'You will return only one response and that will be the cover letter and nothing else.',
    ]
  end
end
