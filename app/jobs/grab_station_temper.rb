require 'rufus-scheduler'
require 'grab/station_temper'
scheduler = Rufus::Scheduler.new
scheduler.every '600s' do
  # do something every day, at morning 3:00
  # (see "man 5 crontab" in your terminal)
  include StationTemper
  fetch_station_temper
end
