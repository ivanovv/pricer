set :application, 'pricer'

set :scm, :git
set :repo_url, 'git://github.com/ivanovv/pricer.git'
#set :repo_url, 'git@github.com:ivanovv/pricer.git'
set :branch, 'master'

set :rails_env, 'production'
set :stage, :production

set :linked_files, %w(config/database.yml config/email.yml config/sphinx.yml)
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

namespace :deploy do

  desc 'Start application'
  task :start do
    on roles(:app) do
      run fetch(:unicorn_start_cmd)
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app) do
      run "[ -f #{fetch(:unicorn_pid)} ] && kill -QUIT `cat #{fetch(:unicorn_pid)}`"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        # Your restart mechanism here, for example:
        with rails_env: fetch(:rails_env) do
          execute "[ -f #{fetch(:unicorn_pid)} ] && kill -USR2 `cat #{fetch(:unicorn_pid)}` || #{fetch(:unicorn_start_cmd)}"
          execute :rake, 'thinking_sphinx:configure'
          execute :rake, 'thinking_sphinx:stop'
          execute :rake, 'thinking_sphinx:reindex'
          execute :rake, 'thinking_sphinx:start'
        end
      end
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within release_path do
        #execute :rake, 'cache:clear'
      end
    end
  end

  after :finishing, 'deploy:cleanup'

end