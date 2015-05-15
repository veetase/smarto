class AddLockableToUsers < ActiveRecord::Migration
  def change
    # Lockable
    change_table(:users) do |t|
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at
      t.datetime :confirmation_expire_at
    end
  end
end
