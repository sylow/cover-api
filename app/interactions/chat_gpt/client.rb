module ChatGpt
  class Client < ActiveInteraction::Base
    ResponseStruct = Struct.new(:response, :summary, :success, :error)

    string :model, default: 'gpt-4o'
    array :messages
    object :user, optional: true  # Add user if you want to log per-user

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
        log_request(success: true, response: api_response, summary: summary)

        # Return a structured response
        ResponseStruct.new(api_response, summary, true, nil)
      rescue => e
        # Log the failed request
        log_request(success: false, response: api_response, error: e.message)

        # Return a structured response indicating failure
        ResponseStruct.new(api_response, nil, false, e.message)
      end
    end

    private

    # Method to log the request and response
    def log_request(success:, response: nil, summary: nil, error: nil)
      ChatLog.create!(
        user: user,
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
