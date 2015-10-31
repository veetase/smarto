class ChangeTemperTypeToTemperTips < ActiveRecord::Migration
  def change
    change_column :temper_tips, :temper, :float
  end
end
