class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :name
      t.string :country, default: "中国"
      t.string :province
      t.string :city
      t.string :district
      t.string :detail
      t.string :zip_code
      t.string :tel
      t.belongs_to :user
      t.timestamps
    end
  end
end
