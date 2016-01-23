class CreateSplashes < ActiveRecord::Migration
  def change
    create_table :splashes do |t|
      t.string :name
      t.attachment :picture
      t.string :description
      t.string :url
      t.datetime :begin_at
      t.datetime :end_at

      t.timestamps null: false
    end
  end
end
