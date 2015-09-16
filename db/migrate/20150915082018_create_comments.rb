class CreateComments < ActiveRecord::Migration
  def up
    create_table :comments do |t|
      t.string :content
      t.references :commentable, polymorphic: true, index: true
      t.belongs_to :user, index: true
      t.timestamps null: false
    end

    comments = []
    SpotComment.find_each do |c|
      comments << {content: c.content, user_id: c.user_id, commentable_type: "Spot", commentable_id: c.spot_id, created_at: c.created_at, updated_at: c.updated_at}
    end
    Comment.create(comments)
    drop_table :spot_comments
  end

  def down
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

    drop_table :comments
  end
end
