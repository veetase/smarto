class CreateSpots < ActiveRecord::Migration
  def change
    create_table :spots do |t|
      t.integer :perception_value, limit: 3
      t.string :perception_tags, array: true
      t.text :comment, null: false
      t.float :avg_temperature, null: false
      t.float :mid_temperature, null: false
      t.float :max_temperature, null: false
      t.float :min_temperature, null: false
      t.timestamp :start_measure_time, null: false
      t.integer :measure_duration, limit: 3
      t.string :image, null: false
      t.string :image_shaped, null: false
      t.boolean :is_public, default: true
      t.st_point :location, geographic: true, null: false
      t.timestamp
      t.belongs_to :user

      t.index :location, using: :gist
    end
  end
end
