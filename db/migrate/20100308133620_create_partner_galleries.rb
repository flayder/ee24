class CreatePartnerGalleries < ActiveRecord::Migration
  def self.up
    create_table :partner_galleries do |t|
      t.string   "title"
      t.string   "link"
      t.integer  "position"
      t.boolean  "main"
      t.boolean  "active"
      t.boolean  "approved",               :default => true
      t.text     "annotation"
      t.text     "meta_title"
      t.text     "meta_keywords"
      t.text     "meta_description"
      t.string   "upload"
      t.boolean  "run_upload",             :default => false
      t.integer "partner_id"
      t.boolean  "published"

      t.timestamps
    end
  end

  def self.down
    drop_table :partner_galleries
  end
end
