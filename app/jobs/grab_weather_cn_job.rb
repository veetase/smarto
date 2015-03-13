require 'grab/weather_cn'
class GrabWeatherCnJob < ActiveJob::Base
  queue_as :default

  def perform
    # Do something later
  end
end
