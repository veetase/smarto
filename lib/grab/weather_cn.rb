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
      weather = {index: index_v, forecast: forecast_v}
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
end