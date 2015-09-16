class AddLikeToStationSpots < ActiveRecord::Migration
  def change
    add_column(:station_spots, :view_count, :integer, default: 0)
    add_column(:station_spots, :comment_count, :integer, default: 0)
    add_column(:station_spots, :like, :integer, default: 0)
  end
end
