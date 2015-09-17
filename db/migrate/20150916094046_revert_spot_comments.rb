class RevertSpotComments < ActiveRecord::Migration
  def change
    create_table :spot_comments do |t|
      t.belongs_to :spot, index: true
      t.belongs_to :user
      t.string :content
      t.timestamps null: false
    end

    comments = []
    Comment.find_each do |c|
      comments << {content: c.content, user_id: c.user_id, spot_id: c.commentable_id, created_at: c.created_at, updated_at: c.updated_at}
    end
    SpotComment.create(comments)
  end
end
