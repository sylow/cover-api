class ApplicationMailer < ActionMailer::Base
  default from: ENV['DEFAULT_FROM_EMAIL'] || "no-reply@jobscraftsman.com"
  layout "mailer"
end
