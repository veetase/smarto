require 'base64'
require 'uri'
require 'openssl'
class WeatherCnSetting < Settingslogic
  source "#{Rails.root}/config/weather.yml"
  namespace Rails.env
  load!
end

class WeatherCn
  include HTTParty
  def initialize(areaid)
    @areaid = areaid
    @date = Time.now.to_s(:number).chop.chop #subtract the last two number
    @app_id_param = WeatherCnSetting.weather_cn.app_id_param
    @app_id = WeatherCnSetting.weather_cn.app_id
    @base_url = WeatherCnSetting.weather_cn.url
    @private_key = WeatherCnSetting.weather_cn.private_key
  end

  def index_v
    request_info("index_v")
  end

  def forecast_v
    request_info("forecast_v")
  end

  def request_info(type)
    part_params = "?areaid=#{@areaid}&type=#{type}&date=#{@date}"
    public_key = @base_url + part_params + "&appid=#{@app_id}"
    url = @base_url + part_params + "&appid=#{@app_id_param}"
    key = generate_key(public_key)
    request_url = url + "&key=#{key}"
    response = JSON.load self.class.get(request_url).force_encoding('UTF-8')
  end

  def fetch_weather
    cache_name = "weather_at_#{@areaid}"
    weather = $redis.get(cache_name)
    if weather
      weather = JSON.load weather
    else
      index = index_v
      forecast = forecast_v
      persist_temperature(forecast) # backup temperature to database, only temperature
      weather = {index: index, forecast: forecast}
      
      $redis.set(cache_name, weather.to_json)
      $redis.expire(cache_name, WeatherCnSetting.weather_cn.cache_peroid)
    end
    weather
  end

  def generate_key(public_key)
    digest = OpenSSL::Digest.new('sha1')
    key = Base64.strict_encode64("#{OpenSSL::HMAC.digest(digest, @private_key, public_key)}")
    URI.encode(key)
  end
  
  private
  def persist_temperature(forecast)
    err = nil
    begin
      byebug
      max_temperature = forecast["f"]["f1"][0]["fc"]
      min_temperature = forecast["f"]["f1"][0]["fd"]
      publish_time = forecast["f"]["f0"]
      area_id = forecast["c"]["c1"]
      altitude = forecast["c"]["c15"]
      
    rescue Exception => e
      err = e.message
      puts "weather info parse error, please check the format from weather cn"
      puts e.message 
      puts e.backtrace.inspect
    end
    
    unless err
      weather_spot = StationSpot::Cn.new(max_temperature: max_temperature, min_temperature: min_temperature, altitude: altitude, publish_time: publish_time, area_id: area_id)
      weather_spot.save
    end
  end
end