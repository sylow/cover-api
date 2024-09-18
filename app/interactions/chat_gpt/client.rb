module ChatGpt
  class Client < ActiveInteraction::Base
    string :model, default: Rails.env.development? ? 'gpt-3.5-turbo' : 'gpt-4-1106-preview'
    array :messages
    object :loggable, class: ActiveRecord::Base

    def execute
      openai_client = OpenAI::Client.new
      api_response = nil
      summary = nil

      begin
        # Make the ChatGPT API call
        api_response = openai_client.chat(
          parameters: {
            model: model,
            messages: messages,
            temperature: 0.7
          }
        )

        # Extract the summary or default message
        summary = api_response.dig("choices", 0, "message", "content") || "No content available"

        # Log the successful request and response
        return log_request(success: true, response: api_response, summary: summary)
      rescue => e
        # Log the failed request
        return log_request(success: false, response: api_response, error: e.message)
      end
    end

    private

    # Method to log the request and response
    def log_request(success:, response: nil, summary: nil, error: nil)
      loggable.chat_logs.create(
        user: loggable.user,
        model: model,
        messages: messages,
        response: response,
        success: success,
        error: error,
        summary: summary
      )
    end
  end
end
