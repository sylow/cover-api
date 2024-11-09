class ApplicationMailer < ActionMailer::Base
  default from: ENV['DEFAULT_FROM_EMAIL'] || "info@jobscraftsman.com"
  layout "mailer"
end
