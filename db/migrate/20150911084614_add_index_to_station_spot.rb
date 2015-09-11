class AddIndexToStationSpot < ActiveRecord::Migration
  def change
    add_index(:station_spots, :created_at)
  end
end
