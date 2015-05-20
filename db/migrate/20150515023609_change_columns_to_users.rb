class ChangeColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_index :users, :phone, unique: true
    execute "CREATE SEQUENCE dou_id_seq INCREMENT BY 7 START WITH 10000"
    add_column :users, :age, :integer, limit: 3

    change_table(:users) do |t|
      t.integer :figure
      t.remove :weight, :height
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at
      t.datetime :confirmation_expire_at
    end
  end
end
