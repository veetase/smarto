require 'grab/weather'
class Api::V3::WeatherController < ApplicationController
  caches_page :realtime

  def realtime
    realtime_weather = Etouch.fetch_weather(params[:area_id])
    render json: realtime_weather.as_json
  end
end
