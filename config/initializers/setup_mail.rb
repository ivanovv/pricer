ActionMailer::Base.smtp_settings = {
  :address              => "smtp.locum.ru",
  :port                 => 2525,
  :domain               => "vivanov2.locum.ru",
  :user_name            => "support@pricer.vivanov2.locum.ru",
  :password             => "******",
  :authentication       => "plain",
  :enable_starttls_auto => false,
  :raise_delivery_errors => true
}

ActionMailer::Base.default_url_options[:host] = "pricer.vivanov2.locum.ru"