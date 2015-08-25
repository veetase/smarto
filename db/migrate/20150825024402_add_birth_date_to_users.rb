class AddBirthDateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :birth_date, :Date, default: '1990-01-01'
  end
end
