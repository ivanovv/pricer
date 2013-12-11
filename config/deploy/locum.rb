server 'lithium.locum.ru', user: 'hosting_vivanov2', roles: %w{web app db}
set :deploy_to, '/home/hosting_vivanov2/projects/pricer'

set :rvm_type, :system
set :rvm_ruby_version, 'ruby-1.9.3-p484'

set :whenever_command, 'rvm use 1.9.3 do bundle exec whenever'

set :unicorn_conf, '/etc/unicorn/pricer.vivanov2.rb'
set :unicorn_pid, '/var/run/unicorn/pricer.vivanov2.pid'
set :unicorn_start_cmd, "(cd #{fetch(:deploy_to)}/current; rvm use 1.9.3 do bundle exec unicorn_rails -Dc #{fetch(:unicorn_conf)})"


set :max_asset_age, 2 ## Set asset age in minutes to test modified date against.

#after 'deploy:updated', 'deploy:assets:determine_modified_assets', 'deploy:assets:conditionally_precompile'

#namespace :deploy do
#  namespace :assets do
#
#    desc 'Figure out modified assets.'
#    #task :determine_modified_assets, :except => {:no_release => true} do
#    task :determine_modified_assets do
#      on roles(fetch(:assets_roles)) do
#        set :updated_assets, capture("find #{latest_release}/app/assets -type d -name .git -prune -o -mmin -#{max_asset_age} -type f -print", :except => {:no_release => true}).split
#      end
#    end
#
#    desc 'Remove callback for asset precompiling unless assets were updated in most recent git commit.'
#    #task :conditionally_precompile, :except => {:no_release => true} do
#    task :conditionally_precompile do
#      on roles(fetch(:assets_roles)) do
#        if fetch(:updated_assets).empty?
#          callback = callbacks[:after].find { |c| c.source == 'deploy:assets:precompile' }
#          callbacks[:after].delete(callback)
#          info('Skipping asset precompiling, no updated assets.')
#        else
#          info("#{fetch(:updated_assets).length} updated assets. Will precompile.")
#        end
#      end
#    end
#
#  end
#end


# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
# and/or per server
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
# setting per server overrides global ssh_options

# fetch(:default_env).merge!(rails_env: :production)
