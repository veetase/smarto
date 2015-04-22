class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :auth_token
      t.datetime :auth_token_expire_at
      t.string :nick_name, default: ""
      t.string :avatar, default: ""
      t.integer :gender, limit: 1
      t.float :height
      t.float :weight
      t.string :tags, array: true
      t.timestamp

      t.index :auth_token, unique: true
    end
  end
end
