class WeatherStationSpot < ActiveRecord::Base
  validates :max_temperature, :min_temperature, numericality: {greater_than_or_equal_to: -50, less_than_or_equal_to: 50}
  validates :area_id, format: { with: /\A101[0-3]\d{5}\z/i}
end