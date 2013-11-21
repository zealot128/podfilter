set :application, 'podfilter'
set :repo_url, 'https://github.com/zealot128/podfilter.de.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/apps/podfilter/prod'
set :scm, :git

set :format, :pretty
set :pty, true
set :log_level, :info

set :linked_files, %w{config/database.yml .env config/email.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads}

set :sidekiq_pid, -> { "tmp/pids/sidekiq.pid" }

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     within release_path do
  #       execute :rake, 'cache:clear'
  #     end
  #   end
  # end

  after :finishing, 'deploy:cleanup'
  # after 'deploy:starting',  'sidekiq:quiet'

  # after 'reverted',  'sidekiq:start'

  # after 'published', 'sidekiq:restart'
  after 'published', :update_crontab
end

# before 'deploy:starting', 'sidekiq:add_default_hooks'


desc "Update crontab with whenever"
task :update_crontab do
  on roles(:all) do
    within release_path do
      execute :bundle, :exec, "whenever --update-crontab #{fetch(:application)}"
    end
  end
end

