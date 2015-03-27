class StationSpot::Cn < WeatherStationSpot
    field :area_id, type: String
    
    validates_format_of :area_id, with: /\A101[0-3]\d{5}\z/i
end