class CreateTelAttributions < ActiveRecord::Migration
  def change
    create_table :tel_attributions do |t|
      t.belongs_to :user, index: true
      t.string :province, null: false
      t.string :city
      t.string :isp, null: false
    end
  end
end
