# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'SimplySusanSays'
set :repo_url, 'git@github.com:cwcarlson10/simply_susan_says'

set :branch, :master 

set :deploy_to, '~/www/simplysusansays.com'
set :scm, :git

set :format, :pretty
set :linked_dirs, %w{log tmp vendor/bundle public/system public/uploads}
set :log_level, :info
# set :log_level, :debug
set :pty, false
# setting queue

# set :linked_files, %w{config/database.yml}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'

  task :create_database do
    on roles(:all), in: :sequence, wait: 2 do 
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:create"
        end
      end 
    end
  end

  task :restart do
    on roles(:app), in: :sequence, wait: 3 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 3 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :publishing, "deploy:restart"
  # after :publishing, "thinking_sphinx:stop"
  # before "thinking_sphinx:rebuild", "thinking_sphinx:stop"
  after :finishing, 'deploy:cleanup'
  before :migrate, 'deploy:create_database'
end

# before 'deploy:update_code', 'thinking_sphinx:stop'
# after  'deploy:update_code', 'thinking_sphinx:start'
# 
# namespace :sphinx do
#   desc "Symlink Sphinx indexes"
#   task :symlink_indexes, :roles => [:app] do
#     run "ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx"
#   end
# end
# 
# after 'deploy:finalize_update', 'sphinx:symlink_indexes'

namespace :db do
  task :full_reset do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec rake db:full_reset"
        end
      end
    end
  end
end

namespace :logs do
  desc "tail rails logs" 

  task :tail do
    ################################################################################
    # Sets log level to debug so we can see program output
    ################################################################################
    set :log_level, :debug
    configure_backend


    on roles(:app) do
      execute "tail -f #{shared_path}/log/#{fetch(:rails_env)}.log"
    end
  end
end


