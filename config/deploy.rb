set :application, 'podfilter'
set :repo_url, 'https://github.com/zealot128/podfilter.de.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/apps/podfilter/prod'
set :scm, :git

set :format, :pretty
set :pty, true
# set :log_level, :debug

set :linked_files, %w{config/database.yml .env}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/upload}

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
end
