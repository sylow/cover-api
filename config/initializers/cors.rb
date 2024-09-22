Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Allow jobcraftsman.com and its subdomains
    allow do
      origins 'https://jobcraftsman.com', 'https://www.jobcraftsman.com'
      resource '/api/v1/*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        credentials: true
    end

    if Rails.env.development?
      origins 'http://localhost:3001'
      resource '/api/v1/*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        credentials: true
    end
  end
end
