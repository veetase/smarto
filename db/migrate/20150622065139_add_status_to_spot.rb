class AddStatusToSpot < ActiveRecord::Migration
  def change
    add_column :spots, :status, :integer, :limit => 1, default: 0
  end
end
