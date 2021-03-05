class CreateCatalogs < ActiveRecord::Migration
  def self.up
    create_table :catalogs do |t|
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
    end
  end

  def self.down
    drop_table :catalogs
  end
end
