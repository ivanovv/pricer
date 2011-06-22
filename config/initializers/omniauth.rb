Rails.application.config.middleware.use OmniAuth::Builder do
  provider :vkontakte, '2383780', '5Nc0ZhTFGjefxGf3irWM', {:client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}}
end