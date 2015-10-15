require 'rufus-scheduler'
s = Rufus::Scheduler.singleton

#grab station temper infomation
s.every '60m' do
  StationTemperJob.perform_async
end

#beijing show heapmap data
s.every '3s' do
  BeijingShowJob.perform_async
end

#backup database
s.cron '0 2 * * *' do
  `backup perform -t bixuange_backup`
end

#update phone attribution
s.cron '0 3 * * *' do
  UpdatePhoneNumberAttributionJob.perform_async
end
