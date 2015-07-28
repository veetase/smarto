class AddColumnsToSpots < ActiveRecord::Migration
  def change
    add_column :spots, :like, :integer, default: 0
    add_column :spots, :height, :float, default: 0
    add_column :spots, :comment_count, :integer, default: 0
  end
end
