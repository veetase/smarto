class AddTimestampToSpot < ActiveRecord::Migration
  def change
    add_column(:spots, :created_at, :datetime)
    add_column(:spots, :updated_at, :datetime)
    add_index :spots, :created_at
  end
end
