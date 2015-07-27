class CreateVouchers < ActiveRecord::Migration
  def change
    create_table :vouchers do |t|
      t.string :name
      t.index :name
      t.string :description
      t.integer :ex_count
      t.string :code
      t.index :code
      t.string :picture
      t.string :type
      t.index :type
      t.integer :max
      t.integer :used_count
      t.integer :status, limit: 1
      t.datetime :expire_at
      t.timestamp
    end
  end
end
