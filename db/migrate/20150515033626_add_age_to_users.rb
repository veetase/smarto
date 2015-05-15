class AddAgeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :age, :integer, limit: 3
  end
end
