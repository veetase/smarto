class StationSpot < ActiveRecord::Base
  set_rgeo_factory_for_column(:location, RGeo::Geographic.spherical_factory(:srid => 4326))
end
