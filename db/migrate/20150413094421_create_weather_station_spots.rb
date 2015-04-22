class CreateWeatherStationSpots < ActiveRecord::Migration
  def change
    create_table :weather_station_spots do |t|
      t.float :max_temperature, null: false
      t.float :min_temperature, null: false
      t.float :altitude
      t.string :area_id
      t.timestamp :publish_time
      t.timestamp
    end
  end
end
