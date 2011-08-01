#ActionMailer::Base.default_url_options[:host] = "pricer.vivanov2.locum.ru"

unless Rails.env.test?
  email_settings = YAML::load(File.open(Rails.root.join("config","email.yml")))
  ActionMailer::Base.smtp_settings = email_settings[Rails.env] unless email_settings[Rails.env].nil?
end