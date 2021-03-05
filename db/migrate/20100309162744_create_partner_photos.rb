class CreatePartnerPhotos < ActiveRecord::Migration
  def self.up
    create_table :partner_photos do |t|
      t.integer  "photo_id"
      t.string   "photo_type"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "image"
      t.string   "title"
      t.boolean  "main",       :default => false
      t.boolean  "on_main",    :default => false
      t.integer  "partner_id"

      t.timestamps
    end
  end

  def self.down
    drop_table :partner_photos
  end
end
