class AddCharacterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :character, :integer, default: 0
  end
end
