class CreateSpotComments < ActiveRecord::Migration
  def change
    create_table :spot_comments do |t|
      t.belongs_to :spot, index: true
      t.belongs_to :user
      t.string :content
      t.timestamps null: false
    end
  end
end
