class DestroyComments < ActiveRecord::Migration
  def up
    drop_table :comments
    drop_table :comment_updates
    remove_column :galleries, :commentation
    remove_column :galleries, :comment_counter
    drop_table :social_comments_counters
  end

  def down
    create_table "comments", :force => true do |t|
      t.integer  "comment_id"
      t.string   "comment_type"
      t.integer  "number"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "text"
      t.integer  "user_id"
      t.integer  "parent_id"
      t.integer  "level"
      t.integer  "position"
      t.boolean  "approved",     default: false
      t.string   "photo"
      t.boolean  "banned",       default: false
      t.integer  "site_id"
      t.datetime "approved_at"
      t.boolean  "dirty",        default: false
    end

    add_index "comments", ["comment_id", "comment_type"], :name => "index_comments_on_comment_id_and_comment_type"
    add_index "comments", ["comment_id"], :name => "index_comments_on_comment_id"
    add_index "comments", ["parent_id"], :name => "index_comments_on_parent_id"
    add_index "comments", ["site_id"], :name => "index_comments_on_site_id"
    add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

    add_column( "galleries", "commentation", :boolean, :default => true )
    add_column("galleries", "comment_counter", :integer, :nil => false, :default => 0)

    create_table "comment_updates", :force => true do |t|
      t.integer  "user_id"
      t.integer  "comment_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "comment_updates", ["comment_id"], :name => "index_comment_updates_on_comment_id"
    add_index "comment_updates", ["user_id"], :name => "index_comment_updates_on_user_id" 

    create_table "social_comments_counters", :force => true do |t|
      t.integer  "social_comments_countable_id"
      t.string   "social_comments_countable_type"
      t.integer  "vk_count",                       :default => 0
      t.integer  "fb_count",                       :default => 0
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "social_comments_counters", ["social_comments_countable_id", "social_comments_countable_type"], :name => "social_comments_counters_id_type_index"
    add_index "social_comments_counters", ["social_comments_countable_id"], :name => "index_social_comments_counters_on_social_comments_countable_id"

  end
end
