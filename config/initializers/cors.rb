Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://jobcraftsman.com', 'https://www.jobcraftsman.com'
    resource '/api/v1/*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end

  # Keep the development configuration if needed
  if Rails.env.development?
    allow do
      origins 'http://localhost:3000'
      resource '/api/v1/*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        credentials: true
    end
  end
end