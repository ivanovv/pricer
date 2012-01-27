set :application, "pricer"
set :repository,  "git://github.com/ivanovv/pricer.git"
set :deploy_via, :remote_cache

deploy_path = "/home/hosting_vivanov2/projects/pricer"

set :user, "hosting_vivanov2"
set :use_sudo, false
set :deploy_to, deploy_path

set :whenever_command, "rvm use 1.9.3 do bundle exec whenever"

set :scm, :git

role :web, "lithium.locum.ru"                          # Your HTTP server, Apache/etc
role :app, "lithium.locum.ru"                          # This may be the same as your `Web` server
role :db,  "lithium.locum.ru", :primary => true        # This is where Rails migrations will run

require "bundler/capistrano"
require "thinking_sphinx/deploy/capistrano"
require "whenever/capistrano"

after "deploy:update_code", :copy_database_config, :copy_email_config

task :copy_database_config, roles => :app do
  db_config = "#{shared_path}/database.yml"
  run "cp #{db_config} #{release_path}/config/database.yml"
end

task :copy_email_config, roles => :app do
  mail_config = "#{shared_path}/email.yml"
  run "cp #{mail_config} #{release_path}/config/email.yml"
end

set :unicorn_conf, "/etc/unicorn/pricer.vivanov2.rb"
set :unicorn_pid, "/var/run/unicorn/pricer.vivanov2.pid"
set :unicorn_start_cmd, "(cd #{deploy_to}/current; rvm use 1.9.3 do bundle exec unicorn_rails -Dc #{unicorn_conf})"

set :bundle_cmd, "rvm use 1.9.3 do bundle"


# - for unicorn - #
namespace :deploy do
  desc "Start application"
  task :start, :roles => :app do
    run unicorn_start_cmd
  end

  desc "Stop application"
  task :stop, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -QUIT `cat #{unicorn_pid}`"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -USR2 `cat #{unicorn_pid}` || #{unicorn_start_cmd}"
  end
end

after "deploy:setup", "thinking_sphinx:shared_sphinx_folder"