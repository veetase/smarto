class CreatePlacements < ActiveRecord::Migration
  def change
    create_table :placements do |t|
      t.references :order, index: true
      t.references :product, index: true
      t.integer :quantity, default: 0
      t.timestamps null: false
    end
    add_foreign_key :placements, :orders
    add_foreign_key :placements, :products
  end
end
