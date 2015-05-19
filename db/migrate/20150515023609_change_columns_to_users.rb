class ChangeColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_index :users, :phone, unique: true
    add_column :users, :dou_id, :integer
    add_index :users, :dou_id, unique: true
    execute "CREATE SEQUENCE users_dou_id_seq OWNED BY
    users.dou_id INCREMENT BY 7 START WITH 10000"
    add_column :users, :age, :integer, limit: 3

    change_table(:users) do |t|
      t.integer :figure
      t.remove :weight, :height
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at
      t.datetime :confirmation_expire_at
      t.remove :email
    end
  end
end
