class AddDouIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dou_id, :integer
    add_index :users, :dou_id, unique: true
    execute "CREATE SEQUENCE users_dou_id_seq OWNED BY
    users.dou_id INCREMENT BY 7 START WITH 10000"
  end
end
