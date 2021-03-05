# encoding: UTF-8

class RemoveForum < ActiveRecord::Migration
  def up
    drop_table :site_forums if table_exists? :site_forums
    drop_table :forums_groups if table_exists? :forums_groups
    drop_table :forum_resource_permissions if table_exists? :forum_resource_permissions
    drop_table :topic_watches if table_exists? :topic_watches
    drop_table :topics if table_exists? :topics
    drop_table :replies if table_exists? :replies
    drop_table :forums if table_exists? :forums
    Section.find_by_controller(:forum).try(:destroy)
  end

  def down
    create_table "site_forums", :force => true do |t|
      t.integer  "site_id"
      t.string   "title"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
    add_index "site_forums", ["site_id"], :name => "index_site_forums_on_site_id"

    create_table "forums_groups", :force => true do |t|
      t.string   "title"
      t.integer  "position"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "site_forum_id"
      t.integer  "forums_count",  :default => 0
    end
    add_index "forums_groups", ["site_forum_id"], :name => "index_forums_groups_on_site_forum_id"

    create_table "forum_resource_permissions", :force => true do |t|
      t.integer  "resource_id"
      t.string   "resource_type"
      t.integer  "site_admin_id"
      t.datetime "created_at",    :null => false
      t.datetime "updated_at",    :null => false
    end
    add_index "forum_resource_permissions", ["site_admin_id", "resource_id", "resource_type"], :name => "forum_resource_permissions_uniq_constraint_index", :unique => true
    add_index "forum_resource_permissions", ["site_admin_id"], :name => "index_forum_resource_permissions_on_site_admin_id"

    create_table "topic_watches", :force => true do |t|
      t.integer  "user_id"
      t.integer  "topic_id"
      t.integer  "forum_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "topic_watches", ["forum_id"], :name => "index_topic_watches_on_forum_id"
    add_index "topic_watches", ["topic_id"], :name => "index_topic_watches_on_topic_id"
    add_index "topic_watches", ["user_id"], :name => "index_topic_watches_on_user_id"

    create_table "topics", :force => true do |t|
      t.integer  "forum_id"
      t.integer  "user_id"
      t.string   "title"
      t.text     "text"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "avatar"
      t.boolean  "closed"
      t.string   "annotation"
      t.integer  "position",      :default => 0
      t.boolean  "up",            :default => false
      t.boolean  "main",          :default => false
      t.integer  "replies_count", :default => 0
      t.string   "photo"
      t.boolean  "approved",      :default => false
      t.integer  "site_id",                          :null => false
      t.boolean  "on_main",       :default => false
      t.boolean  "blacklist",     :default => false
      t.integer  "page_views",    :default => 1
      t.datetime "approved_at"
    end
    add_index "topics", ["forum_id"], :name => "index_topics_on_forum_id"
    add_index "topics", ["site_id"], :name => "index_topics_on_site_id"
    add_index "topics", ["user_id"], :name => "index_topics_on_user_id"

    create_table "replies", :force => true do |t|
      t.integer  "topic_id"
      t.integer  "user_id"
      t.text     "text"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "number",                :default => 1,     :null => false
      t.integer  "forum_id"
      t.string   "photo"
      t.boolean  "approved"
      t.datetime "notifications_sent_at"
      t.integer  "site_id",                                  :null => false
      t.boolean  "expert",                :default => false
      t.boolean  "best",                  :default => false
      t.string   "ancestry"
      t.datetime "approved_at"
      t.boolean  "banned",                :default => false
      t.boolean  "dirty",                 :default => false
    end
    add_index "replies", ["ancestry"], :name => "index_replies_on_ancestry"
    add_index "replies", ["forum_id"], :name => "index_replies_on_forum_id"
    add_index "replies", ["site_id"], :name => "index_replies_on_site_id"
    add_index "replies", ["topic_id"], :name => "index_replies_on_topic_id"
    add_index "replies", ["user_id"], :name => "index_replies_on_user_id"

    create_table "forums", :force => true do |t|
      t.string   "title"
      t.integer  "position"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "annotation"
      t.integer  "forums_group_id"
      t.integer  "replies_count",   :default => 0
      t.integer  "topics_count",    :default => 0
      t.integer  "site_id",                           :null => false
      t.boolean  "premoderation",   :default => true
    end
    add_index "forums", ["forums_group_id"], :name => "index_forums_on_forums_group_id"
    add_index "forums", ["site_id"], :name => "index_forums_on_site_id"
    Section.create!(controller: 'forum', title: 'Форум') unless Section.where(controller: 'forum').count > 0
  end
end
