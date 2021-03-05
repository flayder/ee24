class DropOldPartnerTables < ActiveRecord::Migration
  def self.up
    drop_table :partner_static_docs
    drop_table :partner_galleries
    drop_table :partner_photos
    drop_table :partner_questions
    drop_table :partner_top_infos
  end

  def self.down
    create_table :partner_static_docs do |t|
      t.integer :partner_id
      t.string :title
      t.text :text
      t.string :param
      t.boolean :important
      t.boolean :published
      t.integer :position
      t.timestamps
    end
    add_column :partner_static_docs, :default, :boolean
    add_column :partner_static_docs, :meta_title, :string
    add_column :partner_static_docs, :meta_keywords, :text
    add_column :partner_static_docs, :meta_description, :text
    add_column :partner_static_docs, :main, :boolean, :default => false

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
    add_column :partner_galleries, :annotation_card, :text

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

    create_table :partner_questions do |t|
      t.integer :partner_id
      t.integer :user_id
      t.text :question
      t.text :answer
      t.timestamps
    end

    create_table :partner_top_infos do |t|
      t.integer :partner_id
      t.string :title
      t.string :link
      t.string :image
      t.timestamps
    end
    add_column :partner_top_infos, :published, :boolean
  end
end
