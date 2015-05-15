class RemoveEmailFromUsers < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.remove :email
    end
  end
end
