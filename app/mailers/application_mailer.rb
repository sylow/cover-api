class ApplicationMailer < ActionMailer::Base
  default from: ENV['DEFAULT_FROM_EMAIL'] || "no-reply@jobcraftsman.com"
  layout "mailer"
end
