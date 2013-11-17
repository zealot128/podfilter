# set :output, "/path/to/my/cron_log.log"
job_type :runner, "cd :path && bin/rails runner -e :environment ':task' :output"


every 3.days, at: '03:35' do
  runner 'Source.offline.enqueue'
end
every 2.days, at: '03:00' do
  runner 'Source.inactive.enqueue'
end
every 4.hours do
  runner 'Source.active.enqueue'
end

