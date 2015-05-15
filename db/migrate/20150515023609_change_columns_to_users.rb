class ChangeColumnsToUsers < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.integer :figure
      t.remove :weight, :height
    end
  end
end
