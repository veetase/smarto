class AddDouCoinToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dou_coin, :integer, default: 0
  end
end
