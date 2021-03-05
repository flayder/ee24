class CreateCommentSubscribers < ActiveRecord::Migration
  def change
    create_table :comment_subscribers do |t|
      t.string :subscriberable_type
      t.integer :subscriberable_id
      t.integer :user_id

      t.timestamps
    end
  end
end
