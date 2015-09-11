require 'rufus-scheduler'
s = Rufus::Scheduler.singleton

#grab station temper infomation
s.every '10m' do
  StationTemperJob.perform_async
end

#backup database
s.cron '0 2 * * *' do
  `backup perform -t bixuange_backup`
end

#update phone attribution
s.cron '0 3 * * *' do
  UpdatePhoneNumberAttributionJob.perform_async
end
