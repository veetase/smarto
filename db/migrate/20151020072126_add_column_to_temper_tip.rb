class AddColumnToTemperTip < ActiveRecord::Migration
  def change
    add_column :temper_tips, :month_related_to, :integer, null: false, size: 2
    add_column :temper_tips, :location_related_to, :string, null: false
    add_column :temper_tips, :tags, :string, array: true, default: []
    add_reference :temper_tips, :user, foreign_key: true
  end
end
