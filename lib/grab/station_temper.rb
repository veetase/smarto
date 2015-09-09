module StationTemper
  #only support shenzhen
  @locations = nil

  def fetch_station_temper
    response = HTTParty.get("http://szmb.gov.cn/data_cache/szWeather/szMetroWeather.js")
    raise "Get Station temper info failed" unless response.message == "OK"

    station_spots = []
    temper_info = (JSON.load response.parsed_response)["SZ121_MetroLiveWeather"]

    raise "station api went wrong" if (Time.now - (temper_info["eDate"] / 1000)) > 600
    temper_info.each do |k, value|
      value["stations"].each do |temper|
        station_name = temper["stationName"]
        city = "Shenzhen"
        x, y, z = get_station_location(city, station_name)
        location = "POINT(#{x} #{y})"
        station_spot = {
          location: location,
          height: z,
          temperature: temper["temperature"],
          city: city,
          name: station_name
        }
        station_spots << station_spot
      end
    end
    StationSpot.create!(station_spots)
  end

  def get_station_location(city, station_name)
    @locations = JSON.load(File.read(Rails.root.join('lib', 'grab', 'station_locations.json'))) unless @locations
    return @locations[city][station_name]
  end
end
