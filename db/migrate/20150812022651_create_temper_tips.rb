class CreateTemperTips < ActiveRecord::Migration
  def change
    create_table :temper_tips do |t|
      t.float :temper, null: false
      t.text :tip, null: false
      t.timestamps
    end
  end
end
