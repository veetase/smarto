require 'rufus-scheduler'
scheduler = Rufus::Scheduler.new
scheduler.cron '0 2 * * *' do
  # do something every day, at morning 3:00
  # (see "man 5 crontab" in your terminal)
  `backup perform -t bixuange_backup`
end
