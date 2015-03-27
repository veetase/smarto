class WeatherStationSpot
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :max_temperature, type: Float
  field :min_temperature, type: Float
  field :publish_time, type: Time
  field :altitude, type: Float
  
  validates :max_temperature, :min_temperature, numericality: {greater_than_or_equal_to: -50, less_than_or_equal_to: 50}
end