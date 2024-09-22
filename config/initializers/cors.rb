Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins lambda { |source, env|
      if Rails.env.production?
        # Allow jobcraftsman.com and its subdomains
        source =~ /^https:\/\/(.*\.)?jobcraftsman\.com$/
      else
        source =~ /^http:\/\/localhost(:\d+)?$/ ||
        source =~ /^https:\/\/(.*\.)?jobcraftsman\.com$/
      end
    }
    resource  '*',
              headers: :any,
              methods: [:get, :post, :patch, :put, :delete, :options, :head]
  end
end
