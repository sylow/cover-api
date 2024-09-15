OpenAI.configure do |config|
  config.access_token = ENV.fetch("CHATGPT_API_SECRET_KEY")
  config.request_timeout = 240
end