class StationSpot < ActiveRecord::Base
  set_rgeo_factory_for_column(:location, RGeo::Geographic.spherical_factory(:srid => 4326))
  scope :near, lambda { |longitude, latitude, distance|
    where("ST_Distance(location,
                       "+"'POINT(#{longitude} #{latitude})') < #{distance}")}
end
