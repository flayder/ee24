class CreateCommentUpdates < ActiveRecord::Migration
  def self.up
    create_table :comment_updates do |t|
      t.integer :user_id
      t.integer :comment_id
      t.timestamps
    end
    add_index :comment_updates, :user_id
    add_index :comment_updates, :comment_id
  end

  def self.down
    drop_table :comment_updates
  end
end
