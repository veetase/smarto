class CreateStationSpots < ActiveRecord::Migration
  def change
    create_table :station_spots do |t|
      t.string :city
      t.string :name
      t.st_point :location, geographic: true, null: false
      t.float :temperature, null: false
      t.float :height
      t.timestamps null: false

      t.index :location, using: :gist
    end
  end
end
