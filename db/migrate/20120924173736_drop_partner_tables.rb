class DropPartnerTables < ActiveRecord::Migration
  def up
    drop_table :partners_users
    drop_table :partner_news_docs
  end

  def down
    create_table :partner_news_docs do |t|
      t.string   "title"
      t.text     "annotation"
      t.text     "text"
      t.string   "image"
      t.boolean  "main"
      t.boolean  "active"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "search"
      t.string   "gallery_author"
      t.string   "param"
      t.integer "partner_id"
      t.integer  "news_rubric_id"

      t.timestamps
    end

    create_table :partners_users, :id => false do |t|
      t.integer :partner_id
      t.integer :user_id
    end
  end
end
