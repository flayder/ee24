# encoding: UTF-8

class RemoveBoards < ActiveRecord::Migration
  SITE_ID = Site.find_by_domain('420on.cz').id
  def up
    drop_table :board_types
    drop_table :board_rubrics
    drop_table :board_global_rubrics
    drop_table :boards
    Section.find_by_controller(:board).try(:destroy)
    if column_exists? :board_photos, :site_id
      BoardPhoto.where('site_id != ?', SITE_ID).destroy_all
      remove_column :board_photos, :site_id
    end
  end

  def down
    create_table "board_types", :force => true do |t|
      t.string   "title"
      t.integer  "board_global_rubric_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "link"
      t.boolean  "for_yandex_realty",      :default => false
      t.integer  "site_id"
    end
    add_index "board_types", ["board_global_rubric_id"], :name => "index_board_types_on_board_global_rubric_id"
    add_index "board_types", ["site_id"], :name => "index_board_types_on_site_id"

    create_table "board_rubrics", :force => true do |t|
      t.string   "title"
      t.boolean  "main",                   :default => true
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "board_global_rubric_id"
      t.string   "link"
      t.boolean  "for_yandex_realty",      :default => false
      t.integer  "site_id"
      t.integer  "old_id"
      t.integer  "counter",                :default => 0
    end
    add_index "board_rubrics", ["board_global_rubric_id"], :name => "index_board_rubrics_on_board_global_rubric_id"
    add_index "board_rubrics", ["old_id"], :name => "index_board_rubrics_on_old_id"
    add_index "board_rubrics", ["site_id"], :name => "index_board_rubrics_on_site_id"

    create_table "board_global_rubrics", :force => true do |t|
      t.string   "title"
      t.boolean  "main",       :default => true
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "link"
      t.integer  "site_id"
      t.integer  "old_id"
      t.integer  "counter",    :default => 0
    end
    add_index "board_global_rubrics", ["old_id"], :name => "index_board_global_rubrics_on_old_id"
    add_index "board_global_rubrics", ["site_id"], :name => "index_board_global_rubrics_on_site_id"

    create_table "boards", :force => true do |t|
      t.integer  "user_id"
      t.integer  "board_rubric_id"
      t.integer  "site_id"
      t.string   "company"
      t.string   "title"
      t.text     "text"
      t.text     "contacts"
      t.integer  "board_type_id"
      t.boolean  "main",                   :default => true
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "approved",               :default => false
      t.string   "place"
      t.string   "name"
      t.string   "cost"
      t.integer  "rooms"
      t.integer  "board_global_rubric_id"
      t.string   "email"
      t.string   "tel"
      t.boolean  "archive",                :default => false
      t.integer  "position",               :default => 0
      t.string   "country"
      t.string   "region"
      t.string   "district"
      t.string   "locality_name"
      t.boolean  "for_yandex_realty"
      t.boolean  "is_urban",               :default => false
      t.string   "address"
      t.boolean  "banned",                 :default => false
      t.boolean  "spam"
      t.datetime "approved_at"
      t.integer  "page_views",             :default => 1
      t.string   "text_hash"
      t.string   "realty_type"
      t.float    "square"
      t.integer  "catalog_id"
      t.string   "realty_kind"
    end
    add_index "boards", ["board_global_rubric_id"], :name => "index_boards_on_board_global_rubric_id"
    add_index "boards", ["board_rubric_id"], :name => "index_boards_on_board_rubric_id"
    add_index "boards", ["board_type_id"], :name => "index_boards_on_board_type_id"
    add_index "boards", ["catalog_id"], :name => "index_boards_on_catalog_id"
    add_index "boards", ["site_id"], :name => "index_boards_on_site_id"
    add_index "boards", ["text_hash", "site_id"], :name => "index_boards_on_text_hash_and_site_id", :unique => true

    Section.create!(controller: 'board', title: 'Объявления') unless Section.where(controller: 'board').count > 0
    add_column :board_photos, :site_id, :integer, default: SITE_ID unless column_exists? :board_photos, :site_id
  end
end
