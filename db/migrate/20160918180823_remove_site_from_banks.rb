# encoding : utf-8
class RemoveSiteFromBanks < ActiveRecord::Migration
  def up
    drop_table :atms
    drop_table :bank_card_types
    drop_table :banks
    drop_table :atm_card_types
    Section.where(controller: 'atms').destroy_all
  end

  def down
    create_table "atms", :force => true do |t|
      t.string   "title",      :default => ""
      t.integer  "street_id"
      t.string   "address",    :default => ""
      t.string   "schedule",   :default => ""
      t.datetime "created_at",                 :null => false
      t.datetime "updated_at",                 :null => false
      t.integer  "bank_id"
      t.string   "note",       :default => ""
      t.integer  "city_id"
      t.boolean  "gmaps"
      t.float    "lat"
      t.float    "lng"
      t.integer  "site_id",    :default => 93
    end
    create_table "bank_card_types", :force => true do |t|
      t.string   "title",      :default => ""
      t.string   "image",      :default => ""
      t.datetime "created_at",                 :null => false
      t.datetime "updated_at",                 :null => false
    end
    create_table "banks", :force => true do |t|
      t.string   "title",      :default => ""
      t.datetime "created_at",                 :null => false
      t.datetime "updated_at",                 :null => false
      t.string   "logo"
      t.integer  "site_id",    :default => 93
    end
    create_table "atm_card_types", :force => true do |t|
      t.integer  "atm_id"
      t.integer  "bank_card_type_id"
      t.datetime "created_at",        :null => false
      t.datetime "updated_at",        :null => false
    end
    add_index "atm_card_types", ["atm_id"], :name => "index_atm_card_types_on_atm_id"
    add_index "atm_card_types", ["bank_card_type_id"], :name => "index_atm_card_types_on_bank_card_type_id"
    add_index "atms", ["bank_id"], :name => "index_atms_on_bank_id"
    add_index "atms", ["city_id"], :name => "index_atms_on_city_id"
    add_index "atms", ["street_id"], :name => "index_atms_on_street_id"
    Section.create(controller: 'atms', title: 'Банкоматы')
  end
end
