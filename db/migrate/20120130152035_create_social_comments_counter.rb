class CreateSocialCommentsCounter < ActiveRecord::Migration
  def self.up
    create_table :social_comments_counters do |t|
      t.integer :social_comments_countable_id
      t.string :social_comments_countable_type
      t.integer :vk_count, :default => 0
      t.integer :fb_count, :default => 0

      t.timestamps
    end

    add_index :social_comments_counters, :social_comments_countable_id
  end

  def self.down
    drop_table :social_comments_counters
  end
end