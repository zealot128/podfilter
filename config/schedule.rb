set :output, "/var/www/podfilter/shared/log/cron.log"
job_type :runner, "cd :path && bin/rails runner -e :environment ':task' :output"

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
every :tuesday, at: '07:00' do
  runner 'AutoImport.run_all'
end
