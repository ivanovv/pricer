# _your_login_ - Поменять на ваш логин в панели управления
# _your_project_ - Поменять на имя вашего проекта
# _your_server_ - Поменять на имя вашего сервера (Указано на вкладке "FTP и SSH" вашей панели управления)
# set :repository - Установить расположение вашего репозитория
# У вас должна быть настроена авторизация ssh по сертификатам

set :application, "pricer"
set :repository,  "git://github.com/ivanovv/pricer.git"
set :deploy_via, :remote_cache

deploy_path = "/home/hosting_vivanov2/projects/pricer"

set :user, "hosting_vivanov2"
set :use_sudo, false
set :deploy_to, deploy_path

set :bundle_dir, "~/projects/pricer/shared/bundle"
set :bundle_cmd, "/var/lib/gems/1.8/bin/bundle"

set :whenever_command, "/var/lib/gems/1.8/bin/bundle exec whenever"

set :scm, :git

role :web, "lithium.locum.ru"                          # Your HTTP server, Apache/etc
role :app, "lithium.locum.ru"                          # This may be the same as your `Web` server
role :db,  "lithium.locum.ru", :primary => true # This is where Rails migrations will run

require "bundler/capistrano"
require "thinking_sphinx/deploy/capistrano"
require "whenever/capistrano"

after "deploy:update_code", :copy_database_config

task :copy_database_config, roles => :app do
  db_config = "#{shared_path}/database.yml"
  run "cp #{db_config} #{release_path}/config/database.yml"
end

set :unicorn_rails, "/var/lib/gems/1.8/bin/unicorn_rails"
#set :unicorn_rails, "unicorn_rails"
set :unicorn_conf, "/etc/unicorn/pricer.vivanov2.rb"
set :unicorn_pid, "/var/run/unicorn/pricer.vivanov2.pid"

# - for unicorn - #
namespace :deploy do
  desc "Start application"
  task :start, :roles => :app do
    run "cd #{current_release}; /var/lib/gems/1.8/bin/bundle exec #{unicorn_rails} -Dc #{unicorn_conf}"
  end

  desc "Stop application"
  task :stop, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -QUIT `cat #{unicorn_pid}`"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "cd #{current_release}; [ -f #{unicorn_pid} ] && kill -USR2 `cat #{unicorn_pid}` || /var/lib/gems/1.8/bin/bundle exec #{unicorn_rails} -Dc #{unicorn_conf}"
  end
end

after "deploy:setup", "thinking_sphinx:shared_sphinx_folder"

#require './config/boot'
#require 'hoptoad_notifier/capistrano'


# Build the SASS Stylesheets
before "deploy:restart" do
  rake = fetch(:rake, "rake")
  run "cd #{current_path} && #{rake} sass:build"
end
