class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title, default: ""
      t.text :description, default: ""
      t.decimal :price ,null: false
      t.boolean :published, default: false
      t.integer :quantity, default: 0
      t.timestamps null: false
    end
  end
end
