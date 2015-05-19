class ChangeTypeSpots < ActiveRecord::Migration
  def change
    change_table(:spots) do |t|
      t.integer  :category, default: 1, null: false
    end
  end
end
