class DropCountries < ActiveRecord::Migration
  def up
    drop_table :countries
    drop_table :countries_docs
  end

  def down
    create_table "countries", :force => true do |t|
      t.string   "title"
      t.boolean  "active",     :default => false
      t.boolean  "main",       :default => false
      t.string   "flag"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "world"
      t.integer  "popularity", :default => 0,     :null => false
      t.string   "arms"
      t.string   "case_title"
    end

    create_table "countries_docs", :force => true do |t|
      t.integer  "country_id"
      t.string   "doc_type"
      t.text     "text"
      t.boolean  "active",     :default => false
      t.boolean  "main",       :default => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "title"
    end
  end
end
