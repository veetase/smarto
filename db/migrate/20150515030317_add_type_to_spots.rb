class AddTypeToSpots < ActiveRecord::Migration
  def change
    add_column :spots, :type, :integer, limit: 1
  end
end
