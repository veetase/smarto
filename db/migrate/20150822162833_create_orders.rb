class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true
      t.decimal :total
      t.string :order_no
      t.string :pay_method
      t.integer :status, limit: 1, default: 0
      t.string :ship_carrier
      t.string :ship_no 
      t.timestamps null: false
    end
    add_foreign_key :orders, :users
  end
end
