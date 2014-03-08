set :output, "/apps/podfilter/prod/shared/log/cron.log"
job_type :runner, "cd :path && bin/rails runner -e :environment ':task' :output"
job_type :checker,"pgrep -f -u stefan sidekiq || (cd :path && :environment_variable=:environment bundle exec rake :task --silent :output)"

every 10.minutes do
  command "pgrep -f -u stefan 'sidekiq 2.7' || (rm -f /apps/podfilter/prod/current/log/sidekiq.log && cd /apps/podfilter/prod/current && ~/.rvm/bin/rvm 2.1.1 do bundle exec sidekiq -d -i 0 -P /apps/podfilter/prod/current/tmp/pids/sidekiq.pid -e production -L /apps/podfilter/prod/current/log/sidekiq.log)"
end

every 7.days, at: '03:35' do
  runner 'Source.offline.enqueue'
end
every 2.days, at: '03:00' do
  runner 'Source.inactive.enqueue'
end
every 4.hours do
  runner 'Source.active.enqueue'
end
every 6.hours do
  runner 'Source.update_active_status'
end
every 1.day, at: '6am' do
  rake '-s sitemap:refresh'
end
