class NotificationMailer < ActionMailer::Base

  default :from => "support@pricer.vivanov2.locum.ru", :to => "vic.ivanoff@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.sync.subject
  #
  def sync_stats(prices)
    @prices = prices
    mail
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.parse.subject
  #
  def parse_stats(stats)
    @stats = stats
    mail
  end
end
