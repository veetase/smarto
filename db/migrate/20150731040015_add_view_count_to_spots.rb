class AddViewCountToSpots < ActiveRecord::Migration
  def change
    add_column(:spots, :view_count, :integer, default: 0)
  end
end
