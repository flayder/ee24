class RemoveRealty < ActiveRecord::Migration
  def up
  	Realty::Photo.destroy_all
  	drop_table :realties if table_exists? :realties
  	drop_table :realty_cities if table_exists? :realty_cities
  	drop_table :realty_feedbacks if table_exists? :realty_feedbacks
  	drop_table :realty_localities if table_exists? :realty_localities
  	drop_table :realty_photos if table_exists? :realty_photos
  	drop_table :realty_regions if table_exists? :realty_regions
  end

  def down
  	create_table "realties", :force => true do |t|
	    t.integer  "record_id"
	    t.string   "address"
	    t.float    "lat"
	    t.float    "lng"
	    t.integer  "price_cents"
	    t.string   "currency"
	    t.float    "total_area"
	    t.float    "area_living"
	    t.integer  "floor"
	    t.text     "description_full"
	    t.text     "base_description_full"
	    t.text     "base_description_short"
	    t.integer  "rooms_total"
	    t.integer  "rooms_living"
	    t.integer  "bedrooms"
	    t.boolean  "balkony"
	    t.string   "state"
	    t.datetime "created_at",                                 :null => false
	    t.datetime "updated_at",                                 :null => false
	    t.text     "description_short"
	    t.string   "title"
	    t.integer  "realty_locality_id"
	    t.integer  "realty_region_id"
	    t.integer  "realty_city_id"
	    t.integer  "creator_id"
	    t.string   "realty_for",             :default => "sale"
	    t.string   "source"
	  end
	  add_index "realties", ["realty_city_id"], :name => "index_realties_on_realty_city_id"
	  add_index "realties", ["realty_locality_id"], :name => "index_realties_on_realty_locality_id"
	  add_index "realties", ["realty_region_id"], :name => "index_realties_on_realty_region_id"

	  create_table "realty_cities", :force => true do |t|
	    t.string   "name"
	    t.datetime "created_at", :null => false
	    t.datetime "updated_at", :null => false
	  end

	  create_table "realty_feedbacks", :force => true do |t|
	    t.string   "name"
	    t.string   "phone_number"
	    t.boolean  "urgent_call"
	    t.string   "email"
	    t.text     "body"
	    t.integer  "realty_id"
	    t.datetime "created_at",   :null => false
	    t.datetime "updated_at",   :null => false
	  end
	  add_index "realty_feedbacks", ["realty_id"], :name => "index_realty_feedbacks_on_realty_id"

	  create_table "realty_localities", :force => true do |t|
	    t.string   "name"
	    t.datetime "created_at",     :null => false
	    t.datetime "updated_at",     :null => false
	    t.integer  "realty_city_id"
	  end
	  add_index "realty_localities", ["realty_city_id"], :name => "index_realty_localities_on_realty_city_id"

	  create_table "realty_photos", :force => true do |t|
	    t.integer  "realty_id"
	    t.string   "image"
	    t.datetime "created_at", :null => false
	    t.datetime "updated_at", :null => false
	    t.string   "url"
	    t.boolean  "main"
	  end
	  add_index "realty_photos", ["realty_id"], :name => "index_realty_photos_on_realty_id"

	  create_table "realty_regions", :force => true do |t|
	    t.string   "name"
	    t.datetime "created_at", :null => false
	    t.datetime "updated_at", :null => false
	  end
  end
end
