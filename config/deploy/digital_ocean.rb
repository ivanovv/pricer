server '37.139.29.122', user: 'deploy', roles: %w{web app db}

set :deploy_to, '/home/deploy/apps/pricer'

set :rbenv_type, :system
set :rbenv_ruby, '2.0.0-p247'
