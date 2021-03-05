class CreateCatalog2s < ActiveRecord::Migration
  def self.up
    create_table :catalog2s, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string   "title"
      t.text     "annotation"
      t.text     "text"
      t.string   "email"
      t.string   "site"
      t.string   "adress"
      t.text     "contact"
      t.integer  "star"
      t.boolean  "up"
      t.integer  "position"
      t.integer  "parent_id"
      t.boolean  "main"
      t.boolean  "active"
      t.boolean  "directory"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "place_type_id"
      t.string   "tel"
      t.string   "fax"
      t.string   "logo"
      t.float    "latitude"
      t.float    "longitude"
      t.text     "gmap_annotation"
      t.string   "link"
      t.integer  "counter",              :default => 0,    :null => false
      t.integer  "all_children_counter", :default => 0,    :null => false
      t.string   "meta_title"
      t.text     "meta_keywords"
      t.text     "meta_description"
      t.text     "about"
      t.integer  "city_id"
      t.boolean  "approved",             :default => true
      t.string   "logo_alt"
      t.string   "page_title"
      t.timestamps
    end
  end

  def self.down
    drop_table :catalog2s
  end
end
