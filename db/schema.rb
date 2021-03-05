# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20210305134329) do

  create_table "ad_agencies", :force => true do |t|
    t.string   "title",      :default => ""
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "ad_codes", :force => true do |t|
    t.text     "code"
    t.integer  "ad_section_id"
    t.string   "ad_section_type"
    t.integer  "site_id"
    t.string   "url"
    t.string   "banner_type"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "title",           :default => ""
  end

  add_index "ad_codes", ["ad_section_id", "ad_section_type"], :name => "index_ad_codes_on_ad_section_id_and_ad_section_type"
  add_index "ad_codes", ["site_id"], :name => "index_ad_codes_on_site_id"

  create_table "ad_formats", :force => true do |t|
    t.string   "title",      :default => ""
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "ad_surfaces", :force => true do |t|
    t.string   "title",        :default => ""
    t.text     "description"
    t.string   "photo"
    t.string   "second_photo"
    t.string   "address",      :default => ""
    t.integer  "city_id"
    t.integer  "street_id"
    t.integer  "ad_agency_id"
    t.integer  "ad_format_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.float    "lat"
    t.float    "lng"
  end

  add_index "ad_surfaces", ["ad_agency_id"], :name => "index_ad_surfaces_on_ad_agency_id"
  add_index "ad_surfaces", ["ad_format_id"], :name => "index_ad_surfaces_on_ad_format_id"
  add_index "ad_surfaces", ["city_id"], :name => "index_ad_surfaces_on_city_id"
  add_index "ad_surfaces", ["street_id"], :name => "index_ad_surfaces_on_street_id"

  create_table "black_list_words", :force => true do |t|
    t.string   "lemma"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "black_list_words", ["lemma"], :name => "index_black_list_words_on_lemma", :unique => true

  create_table "board_photos", :force => true do |t|
    t.integer  "photoable_id"
    t.string   "photoable_type"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "migrated",       :default => false
    t.integer  "position"
  end

  add_index "board_photos", ["photoable_id", "photoable_type"], :name => "index_board_photos_on_photoable_id_and_photoable_type"
  add_index "board_photos", ["position"], :name => "index_board_photos_on_position"

  create_table "catalog_descriptions", :force => true do |t|
    t.integer  "catalog_id"
    t.string   "language"
    t.string   "title"
    t.text     "annotation"
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "catalog_descriptions", ["language"], :name => "index_catalog_descriptions_on_language"

  create_table "catalog_galleries", :id => false, :force => true do |t|
    t.integer "catalog_id"
    t.integer "gallery_id"
  end

  add_index "catalog_galleries", ["gallery_id", "catalog_id"], :name => "index_catalog_galleries_on_gallery_id_and_catalog_id"

  create_table "catalog_join_rubrics", :force => true do |t|
    t.integer "catalog_id"
    t.integer "catalog_rubric_id"
  end

  add_index "catalog_join_rubrics", ["catalog_id", "catalog_rubric_id"], :name => "index_catalog_join_rubrics_on_catalog_id_and_catalog_rubric_id"

  create_table "catalog_ratings", :force => true do |t|
    t.integer  "year"
    t.integer  "month"
    t.integer  "catalog_id"
    t.float    "rating",     :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "catalog_ratings", ["catalog_id"], :name => "index_catalog_ratings_on_catalog_id"

  create_table "catalog_rubric_counters", :force => true do |t|
    t.integer  "catalog_rubric_id"
    t.string   "language"
    t.integer  "counter",           :default => 0
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "catalog_rubric_counters", ["language"], :name => "index_catalog_rubric_counters_on_language"

  create_table "catalog_rubrics", :force => true do |t|
    t.string   "title"
    t.string   "link"
    t.integer  "position"
    t.integer  "parent_id"
    t.boolean  "main"
    t.integer  "all_children_counter", :default => 0,    :null => false
    t.boolean  "approved",             :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "param"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth",                :default => 0
    t.integer  "old_id"
    t.integer  "site_id"
    t.string   "english_title"
  end

  add_index "catalog_rubrics", ["old_id"], :name => "index_catalog_global_rubrics_on_old_id"
  add_index "catalog_rubrics", ["parent_id"], :name => "index_catalog_global_rubrics_on_parent_id"
  add_index "catalog_rubrics", ["site_id"], :name => "index_catalog_global_rubrics_on_site_id"

  create_table "catalogs", :force => true do |t|
    t.string   "email"
    t.string   "site_url"
    t.string   "address"
    t.text     "contact"
    t.integer  "position"
    t.integer  "parent_id"
    t.boolean  "main"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tel"
    t.string   "fax"
    t.string   "logo"
    t.text     "gmap_annotation"
    t.string   "link"
    t.integer  "counter",              :default => 0,     :null => false
    t.integer  "all_children_counter", :default => 0,     :null => false
    t.string   "meta_title"
    t.text     "meta_keywords"
    t.text     "meta_description"
    t.text     "about"
    t.integer  "site_id"
    t.boolean  "approved",             :default => false
    t.string   "logo_alt"
    t.string   "param"
    t.boolean  "yandex_geocoded",      :default => false
    t.string   "yandex_icon"
    t.string   "region_extension"
    t.string   "locality"
    t.string   "street_address"
    t.string   "extended_address"
    t.integer  "postal_code"
    t.boolean  "hcard_converted",      :default => false
    t.float    "lat"
    t.float    "lng"
    t.boolean  "gmaps"
    t.integer  "user_id"
    t.datetime "approved_at"
    t.integer  "page_views",           :default => 1
    t.boolean  "is_commentable",       :default => true
    t.boolean  "recommend",            :default => false
    t.boolean  "russian_language"
  end

  add_index "catalogs", ["site_id"], :name => "index_catalog2s_on_site_id"
  add_index "catalogs", ["user_id"], :name => "index_catalog2s_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "logo"
    t.text     "description",  :limit => 16777215
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "english_name"
  end

  create_table "cities", :force => true do |t|
    t.string   "title"
    t.string   "link"
    t.string   "portal_title"
    t.string   "region"
    t.datetime "created_at"
    t.string   "number"
    t.string   "map_zoom"
    t.string   "induced_title"
    t.float    "lat"
    t.float    "lng"
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "comment_subscribers", :force => true do |t|
    t.string   "subscriberable_type"
    t.integer  "subscriberable_id"
    t.integer  "user_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.text     "text"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "communities", :force => true do |t|
    t.string   "name"
    t.string   "logo"
    t.integer  "category_id"
    t.text     "description", :limit => 16777215
    t.text     "rules",       :limit => 16777215
    t.integer  "user_id"
    t.boolean  "banned",                          :default => false
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.boolean  "open",                            :default => true
  end

  create_table "design_stylesheets", :force => true do |t|
    t.string   "name"
    t.text     "body",       :limit => 16777215
    t.integer  "site_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "design_stylesheets", ["name", "site_id"], :name => "index_design_stylesheets_on_name_and_site_id", :unique => true
  add_index "design_stylesheets", ["site_id"], :name => "index_design_stylesheets_on_site_id"

  create_table "design_templates", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.integer  "site_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "design_templates", ["name", "site_id"], :name => "index_design_templates_on_name_and_site_id", :unique => true
  add_index "design_templates", ["site_id"], :name => "index_design_templates_on_site_id"

  create_table "dictionaries", :force => true do |t|
    t.string   "link",        :null => false
    t.integer  "site_id",     :null => false
    t.text     "description"
    t.string   "title",       :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "dictionaries", ["site_id"], :name => "index_dictionaries_on_site_id"

  create_table "dictionary_objects", :force => true do |t|
    t.string   "title"
    t.text     "text"
    t.string   "letter",     :limit => 5
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rubric_id"
    t.integer  "site_id"
    t.boolean  "approved",                :default => false
    t.integer  "user_id"
    t.string   "old_model"
    t.integer  "old_id"
    t.string   "image"
  end

  add_index "dictionary_objects", ["id"], :name => "index_dictionary_objects_on_id_and_type"
  add_index "dictionary_objects", ["rubric_id"], :name => "index_dictionary_objects_on_rubric_id"
  add_index "dictionary_objects", ["site_id"], :name => "index_dictionary_objects_on_site_id"
  add_index "dictionary_objects", ["user_id"], :name => "index_dictionary_objects_on_user_id"

  create_table "dictionary_rubrics", :force => true do |t|
    t.string   "title",         :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
    t.integer  "dictionary_id"
    t.string   "image"
  end

  add_index "dictionary_rubrics", ["dictionary_id"], :name => "index_dictionary_rubrics_on_dictionary_id"
  add_index "dictionary_rubrics", ["site_id"], :name => "index_dictionary_rubrics_on_site_id"

  create_table "doc_announces", :force => true do |t|
    t.string   "image"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "doc_global_rubrics", :force => true do |t|
    t.string   "title"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "user_added",    :default => false
    t.integer  "site_id"
    t.integer  "position"
    t.string   "english_title"
  end

  add_index "doc_global_rubrics", ["link"], :name => "index_doc_global_rubrics_on_link"
  add_index "doc_global_rubrics", ["position"], :name => "index_doc_global_rubrics_on_position"
  add_index "doc_global_rubrics", ["site_id"], :name => "index_global_rubrics_on_site_id"

  create_table "doc_ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "ratable_id"
    t.string   "ratable_type"
    t.integer  "value",        :limit => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "doc_ratings", ["ratable_id", "ratable_type"], :name => "index_doc_ratings_on_ratable_id_and_ratable_type"
  add_index "doc_ratings", ["ratable_id"], :name => "index_doc_ratings_on_ratable_id"
  add_index "doc_ratings", ["user_id"], :name => "index_doc_ratings_on_user_id"

  create_table "doc_rubrics", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link"
    t.integer  "global_rubric_id"
    t.string   "show_url"
    t.boolean  "user_added",       :default => false
    t.integer  "site_id"
    t.integer  "position"
    t.string   "english_title"
  end

  add_index "doc_rubrics", ["global_rubric_id"], :name => "index_rubric_docs_on_global_rubric_id"
  add_index "doc_rubrics", ["site_id"], :name => "index_rubric_docs_on_site_id"

  create_table "docs", :force => true do |t|
    t.integer  "doc_rubric_id"
    t.string   "title"
    t.text     "annotation"
    t.text     "text",            :limit => 16777215
    t.boolean  "main",                                :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gallery_author"
    t.string   "param"
    t.boolean  "approved",                            :default => false
    t.boolean  "not_in_rss",                          :default => false
    t.integer  "views_rating",                        :default => 0
    t.integer  "site_id"
    t.integer  "user_id"
    t.datetime "approved_at"
    t.integer  "page_views",                          :default => 1
    t.string   "text_hash"
    t.boolean  "no_watermark",                        :default => false
    t.string   "search"
    t.boolean  "pictureless",                         :default => false
    t.integer  "news_doc_doc_id"
    t.integer  "news_doc_id"
    t.boolean  "important",                           :default => false
    t.boolean  "is_commentable",                      :default => true
    t.boolean  "long_image",                          :default => false
    t.string   "hero"
    t.string   "quote"
    t.boolean  "top_main",                            :default => false
    t.string   "language",                            :default => "ru"
    t.boolean  "yandex_zen",                          :default => false
    t.datetime "approve_on"
  end

  add_index "docs", ["doc_rubric_id"], :name => "index_docs_on_rubric_doc_id"
  add_index "docs", ["news_doc_doc_id"], :name => "index_docs_on_news_doc_doc_id"
  add_index "docs", ["news_doc_id"], :name => "index_docs_on_news_doc_id"
  add_index "docs", ["param", "site_id"], :name => "index_docs_on_param_and_site_id"
  add_index "docs", ["site_id"], :name => "index_docs_on_site_id"
  add_index "docs", ["text_hash", "site_id"], :name => "index_docs_on_text_hash_and_site_id", :unique => true
  add_index "docs", ["title", "site_id", "approved"], :name => "index_docs_on_title_and_site_id_and_approved"
  add_index "docs", ["user_id"], :name => "index_docs_on_user_id"

  create_table "event_rubrics", :force => true do |t|
    t.string   "title"
    t.string   "link"
    t.boolean  "main"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "show_url"
    t.boolean  "user_added",           :default => false
    t.integer  "site_id"
    t.integer  "position"
    t.boolean  "afisha_main",          :default => true
    t.integer  "afisha_main_position"
    t.text     "description"
    t.text     "main_banner"
    t.string   "english_title"
  end

  add_index "event_rubrics", ["site_id"], :name => "index_event_rubrics_on_site_id"

  create_table "events", :force => true do |t|
    t.string   "title"
    t.text     "annotation"
    t.text     "text"
    t.text     "address"
    t.integer  "place_id"
    t.integer  "event_rubric_id"
    t.boolean  "main"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_date"
    t.datetime "finish_date"
    t.string   "gallery_author"
    t.string   "param"
    t.integer  "accepted_users_count", :default => 0
    t.boolean  "approved",             :default => false
    t.integer  "site_id",              :default => 1
    t.integer  "views_rating",         :default => 0
    t.integer  "user_id"
    t.datetime "approved_at"
    t.integer  "page_views",           :default => 1
    t.string   "text_hash"
    t.boolean  "is_commentable",       :default => true
    t.string   "place"
    t.string   "site_url"
    t.string   "price"
    t.string   "promote_link"
    t.boolean  "show_time",            :default => false
    t.boolean  "long_image",           :default => false
    t.string   "language",             :default => "ru"
  end

  add_index "events", ["event_rubric_id"], :name => "index_events_on_event_rubric_id"
  add_index "events", ["param", "site_id"], :name => "index_events_on_param_and_site_id"
  add_index "events", ["site_id"], :name => "index_events_on_city_id"
  add_index "events", ["text_hash", "site_id"], :name => "index_events_on_text_hash_and_site_id", :unique => true
  add_index "events", ["title", "site_id", "approved"], :name => "index_events_on_title_and_site_id_and_approved"
  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "exchange_rates", :force => true do |t|
    t.float    "eur_czk_rate", :default => 0.0
    t.float    "usd_czk_rate", :default => 0.0
    t.float    "rub_czk_rate", :default => 0.0
    t.date     "date_of_rate",                  :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.float    "uah_czk_rate", :default => 0.0
  end

  create_table "external_doc_rubrics", :force => true do |t|
    t.string   "title"
    t.integer  "site_id"
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "external_doc_rubrics", ["site_id"], :name => "index_external_doc_rubrics_on_site_id"

  create_table "external_docs", :force => true do |t|
    t.string   "url"
    t.integer  "site_id"
    t.integer  "user_id"
    t.integer  "external_doc_rubric_id"
    t.boolean  "approved",               :default => false
    t.boolean  "main",                   :default => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "title"
    t.string   "image"
    t.datetime "approved_at"
  end

  add_index "external_docs", ["external_doc_rubric_id"], :name => "index_external_docs_on_external_doc_rubric_id"
  add_index "external_docs", ["site_id"], :name => "index_external_docs_on_site_id"
  add_index "external_docs", ["url", "site_id"], :name => "index_external_docs_on_url_and_site_id", :unique => true
  add_index "external_docs", ["user_id"], :name => "index_external_docs_on_user_id"

  create_table "forecast_anchors", :force => true do |t|
    t.string   "text"
    t.integer  "limit"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "forecast_data", :force => true do |t|
    t.datetime "timestamp"
    t.integer  "temperature"
    t.string   "icon"
    t.integer  "pressure"
    t.float    "wind_speed"
    t.integer  "location_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "humidity"
    t.integer  "max_temperature"
    t.integer  "min_temperature"
    t.string   "wind_direction"
  end

  add_index "forecast_data", ["location_id", "timestamp"], :name => "index_forecast_data_on_location_id_and_timestamp", :unique => true
  add_index "forecast_data", ["location_id"], :name => "index_forecast_data_on_location_id"

  create_table "forecast_districts", :force => true do |t|
    t.string   "name"
    t.integer  "site_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.boolean  "active",     :default => true
  end

  add_index "forecast_districts", ["site_id"], :name => "index_forecast_districts_on_site_id"

  create_table "forecast_icons", :force => true do |t|
    t.string   "background"
    t.integer  "site_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "forecast_icons", ["site_id"], :name => "index_forecast_icons_on_site_id"

  create_table "forecast_locations", :force => true do |t|
    t.string   "name"
    t.integer  "district_id"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "foreca_id"
    t.string   "param"
  end

  add_index "forecast_locations", ["district_id"], :name => "index_forecast_locations_on_district_id"
  add_index "forecast_locations", ["foreca_id"], :name => "index_forecast_locations_on_foreca_id"

  create_table "forecast_settings", :force => true do |t|
    t.integer  "site_id"
    t.string   "login"
    t.string   "password"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "background"
    t.string   "subdomain"
    t.integer  "default_location_id"
  end

  add_index "forecast_settings", ["site_id"], :name => "index_forecast_settings_on_site_id"

  create_table "forecast_widgets", :force => true do |t|
    t.string   "url"
    t.integer  "location_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "anchor_id"
  end

  add_index "forecast_widgets", ["anchor_id"], :name => "index_forecast_widgets_on_anchor_id"
  add_index "forecast_widgets", ["location_id"], :name => "index_forecast_widgets_on_location_id"

  create_table "friends_approves", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friends_approves", ["user_id", "friend_id"], :name => "index_friends_approves_on_user_id_and_friend_id", :unique => true

  create_table "galleries", :force => true do |t|
    t.string   "title"
    t.integer  "photo_rubric_id"
    t.integer  "site_id"
    t.boolean  "approved",         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "annotation"
    t.integer  "root_id"
    t.string   "about"
    t.text     "meta_title"
    t.text     "meta_keywords"
    t.text     "meta_description"
    t.text     "annotation_card"
    t.boolean  "no_watermark",     :default => false
    t.boolean  "post_lj",          :default => false
    t.integer  "views_rating",     :default => 0
    t.integer  "user_id"
    t.boolean  "not_on_main",      :default => false
    t.datetime "approved_at"
    t.integer  "page_views",       :default => 1
    t.boolean  "is_commentable",   :default => true
  end

  add_index "galleries", ["photo_rubric_id"], :name => "index_galleries_on_photo_global_rubric_id"
  add_index "galleries", ["root_id"], :name => "index_galleries_on_root_id"
  add_index "galleries", ["site_id"], :name => "index_galleries_on_city_id"
  add_index "galleries", ["user_id"], :name => "index_galleries_on_user_id"

  create_table "industries", :force => true do |t|
    t.string   "title"
    t.boolean  "main",            :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "job_items_count", :default => 0
  end

  create_table "ips", :force => true do |t|
    t.string   "ip",             :limit => 30, :default => ""
    t.integer  "ip_object_id"
    t.string   "ip_object_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ips", ["ip_object_id", "ip_object_type"], :name => "index_ips_on_ip_object_id_and_ip_object_type"
  add_index "ips", ["ip_object_id"], :name => "index_ips_on_ip_object_id"

  create_table "linkers", :force => true do |t|
    t.string   "url"
    t.integer  "counter",    :default => 0
    t.text     "seo_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
  end

  add_index "linkers", ["site_id"], :name => "index_linkers_on_site_id"

  create_table "main_block_rubrics", :force => true do |t|
    t.integer  "main_block_id"
    t.integer  "rubric_id"
    t.string   "rubric_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "main_block_rubrics", ["main_block_id", "rubric_id", "rubric_type"], :name => "main_block_rubrics_unique_main_blocks_rubrics", :unique => true

  create_table "main_blocks", :force => true do |t|
    t.string   "doc_type"
    t.integer  "site_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "position"
    t.string   "title"
    t.string   "path"
    t.text     "banner"
  end

  add_index "main_blocks", ["site_id"], :name => "index_main_blocks_on_site_id"

  create_table "main_menu_links", :force => true do |t|
    t.integer  "site_id"
    t.string   "title"
    t.string   "path"
    t.integer  "position"
    t.string   "css_class"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "main_menu_links", ["site_id"], :name => "index_main_menu_links_on_site_id"

  create_table "main_sections", :force => true do |t|
    t.string   "name"
    t.string   "identity"
    t.boolean  "active"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "messages", :force => true do |t|
    t.string   "title"
    t.text     "text"
    t.integer  "user_id"
    t.integer  "sender_id"
    t.boolean  "admin",       :default => false
    t.boolean  "viewed",      :default => false
    t.string   "buttons"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "question_id"
  end

  add_index "messages", ["sender_id"], :name => "index_messages_on_sender_id"
  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "metrika_api_account_search_queries", :force => true do |t|
    t.string   "body"
    t.integer  "page_views"
    t.integer  "visits"
    t.integer  "url_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "metrika_api_account_search_queries", ["url_id"], :name => "index_metrika_api_account_search_queries_on_url_id"

  create_table "metrika_api_account_urls", :force => true do |t|
    t.string   "body"
    t.integer  "metrika_api_account_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "metrika_api_account_urls", ["metrika_api_account_id"], :name => "index_metrika_api_account_urls_on_metrika_api_account_id"

  create_table "metrika_api_accounts", :force => true do |t|
    t.string   "app_id"
    t.string   "app_password"
    t.string   "token"
    t.integer  "site_id",      :null => false
    t.string   "counter_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "metrika_api_accounts", ["site_id"], :name => "index_metrika_api_accounts_on_site_id"

  create_table "mobile_devices", :force => true do |t|
    t.string   "token"
    t.string   "site_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "mobile_devices", ["site_id", "token"], :name => "index_mobile_devices_on_site_id_and_token", :unique => true

  create_table "permissions", :force => true do |t|
    t.integer  "site_admin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "section_id"
  end

  add_index "permissions", ["section_id"], :name => "index_permissions_on_section_id"
  add_index "permissions", ["site_admin_id", "section_id"], :name => "index_permissions_on_site_admin_id_and_section_id", :unique => true
  add_index "permissions", ["site_admin_id"], :name => "index_permissions_on_site_admin_id"

  create_table "photo_rubrics", :force => true do |t|
    t.string   "title"
    t.string   "link"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "with_rating", :default => false
    t.integer  "site_id"
  end

  add_index "photo_rubrics", ["site_id"], :name => "index_photo_global_rubrics_on_site_id"

  create_table "photos", :force => true do |t|
    t.integer  "photo_id"
    t.string   "photo_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.string   "title"
    t.boolean  "main",             :default => false
    t.boolean  "on_main",          :default => false
    t.string   "comment",          :default => ""
    t.boolean  "watermarked",      :default => false
    t.boolean  "image_processing"
    t.boolean  "commented",        :default => false
  end

  add_index "photos", ["photo_id", "photo_type"], :name => "index_photos_on_photo_id_and_photo_type"
  add_index "photos", ["photo_id"], :name => "index_photos_on_photo_id"

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "content",      :limit => 16777215
    t.integer  "user_id"
    t.integer  "community_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.datetime "deleted_at"
  end

  add_index "posts", ["deleted_at"], :name => "index_posts_on_deleted_at"

  create_table "profession_objects", :force => true do |t|
    t.integer  "profession_id"
    t.integer  "vacancy_id"
    t.integer  "resume_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profession_objects", ["profession_id", "resume_id"], :name => "index_profession_objects_on_profession_id_and_resume_id"
  add_index "profession_objects", ["profession_id", "vacancy_id"], :name => "index_profession_objects_on_profession_id_and_vacancy_id"
  add_index "profession_objects", ["resume_id", "profession_id"], :name => "index_profession_objects_on_resume_id_and_profession_id"
  add_index "profession_objects", ["vacancy_id", "profession_id"], :name => "index_profession_objects_on_vacancy_id_and_profession_id"

  create_table "professions", :force => true do |t|
    t.string   "title"
    t.integer  "vacancy_count",   :default => 0,     :null => false
    t.integer  "industry_id"
    t.boolean  "main",            :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "resumes_count",   :default => 0,     :null => false
    t.integer  "job_items_count", :default => 0
  end

  add_index "professions", ["industry_id"], :name => "index_professions_on_industry_id"

  create_table "questions", :force => true do |t|
    t.string   "title"
    t.text     "content",     :limit => 16777215
    t.text     "answer",      :limit => 16777215
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.datetime "deleted_at"
    t.boolean  "approved",                        :default => false
    t.string   "language",                        :default => "ru"
  end

  add_index "questions", ["deleted_at"], :name => "index_questions_on_deleted_at"

  create_table "ratings", :force => true do |t|
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.integer  "user_id"
    t.boolean  "positive",      :default => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "redirects", :force => true do |t|
    t.string   "from"
    t.string   "to"
    t.integer  "site_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "redirects", ["from"], :name => "index_redirects_on_from"
  add_index "redirects", ["site_id"], :name => "index_redirects_on_site_id"

  create_table "region_cities", :force => true do |t|
    t.string   "title"
    t.integer  "region_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "region_cities", ["region_id"], :name => "index_region_cities_on_region_id"

  create_table "regions", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "request_forms", :force => true do |t|
    t.string   "full_name"
    t.string   "email"
    t.string   "phone_number"
    t.date     "birthday"
    t.text     "comment",      :limit => 16777215
    t.integer  "docable_id"
    t.string   "docable_type"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "resumes", :force => true do |t|
    t.integer  "user_id"
    t.text     "text"
    t.string   "money"
    t.string   "busy"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.integer  "industry_id"
    t.text     "contacts"
    t.boolean  "archive",     :default => false
    t.boolean  "approved",    :default => false
    t.datetime "approved_at"
    t.integer  "page_views",  :default => 1
    t.string   "text_hash"
  end

  add_index "resumes", ["industry_id"], :name => "index_resumes_on_industry_id"
  add_index "resumes", ["text_hash"], :name => "index_resumes_on_text_hash_and_site_id", :unique => true
  add_index "resumes", ["user_id"], :name => "index_resumes_on_user_id"

  create_table "rubric_permissions", :force => true do |t|
    t.integer  "rubric_id"
    t.string   "rubric_type"
    t.integer  "site_admin_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "rubric_permissions", ["site_admin_id", "rubric_id", "rubric_type"], :name => "rubric_permissions_site_admin_rubric_constraint", :unique => true
  add_index "rubric_permissions", ["site_admin_id"], :name => "index_rubric_permissions_on_site_admin_id"

  create_table "rubric_twitters", :force => true do |t|
    t.integer  "rubric_twitter_id"
    t.integer  "site_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "twittable_id"
    t.string   "twittable_type"
  end

  add_index "rubric_twitters", ["rubric_twitter_id", "site_id"], :name => "site_rubric_rubric_twitters_uniq_ids"
  add_index "rubric_twitters", ["site_id"], :name => "index_site_rubric_rubric_twitters_on_site_id"

  create_table "search_queries", :force => true do |t|
    t.string   "query"
    t.integer  "site_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "search_queries", ["site_id"], :name => "index_search_queries_on_site_id"

  create_table "sections", :force => true do |t|
    t.string   "title",        :default => ""
    t.string   "controller",   :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.boolean  "with_rubrics", :default => false
    t.boolean  "with_city",    :default => false
    t.boolean  "in_sitemap",   :default => false
  end

  create_table "seos", :force => true do |t|
    t.text     "about"
    t.string   "title"
    t.text     "description"
    t.text     "keywords"
    t.integer  "seo_id"
    t.string   "seo_type"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "path"
    t.text     "text"
    t.text     "sub_text"
    t.string   "news_keywords"
    t.string   "language",      :default => "ru"
  end

  add_index "seos", ["seo_id", "seo_type"], :name => "index_seos_on_seo_id_and_seo_type"
  add_index "seos", ["site_id"], :name => "index_seos_on_site_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "shared_photos", :force => true do |t|
    t.integer  "doc_id"
    t.string   "doc_type"
    t.string   "image"
    t.string   "main_photo_url"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "site_admins", :force => true do |t|
    t.integer  "site_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",               :default => ""
    t.boolean  "admin_panel_access", :default => false
  end

  add_index "site_admins", ["site_id"], :name => "index_site_admins_on_site_id"
  add_index "site_admins", ["user_id"], :name => "index_site_admins_on_user_id"

  create_table "site_sections", :force => true do |t|
    t.integer  "site_id"
    t.integer  "section_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "site_sections", ["section_id"], :name => "index_site_sections_on_section_id"
  add_index "site_sections", ["site_id"], :name => "index_site_sections_on_site_id"

  create_table "sites", :force => true do |t|
    t.string   "portal_title",      :default => ""
    t.string   "domain",            :default => ""
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_title",       :default => ""
    t.string   "logo"
    t.string   "favicon"
    t.boolean  "is_partner",        :default => false
    t.string   "map_provider",      :default => "yandex"
    t.string   "subdomain"
    t.boolean  "omniauth_enabled",  :default => false
    t.boolean  "active",            :default => true
    t.string   "watermark"
    t.integer  "time_zone"
    t.string   "background"
    t.string   "background_link"
    t.boolean  "pictureless",       :default => false
    t.text     "robots"
    t.boolean  "repeat_background", :default => true
    t.string   "email"
  end

  add_index "sites", ["city_id"], :name => "index_sites_on_city_id"

  create_table "social_widget_codes", :force => true do |t|
    t.string   "widget_type", :default => ""
    t.text     "code"
    t.integer  "site_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "stat_counters", :force => true do |t|
    t.string   "model"
    t.integer  "count"
    t.date     "date"
    t.integer  "site_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "stat_counters", ["model", "date", "site_id"], :name => "index_stat_counters_on_model_and_date_and_site_id", :unique => true
  add_index "stat_counters", ["site_id"], :name => "index_stat_counters_on_site_id"

  create_table "static_docs", :force => true do |t|
    t.string   "title"
    t.text     "text"
    t.boolean  "active",           :default => false
    t.boolean  "main",             :default => false
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "meta_title"
    t.text     "meta_keywords"
    t.text     "meta_description"
    t.integer  "site_id",                             :null => false
    t.integer  "position"
  end

  add_index "static_docs", ["site_id"], :name => "index_static_docs_on_site_id"

  create_table "streets", :force => true do |t|
    t.string   "title",      :default => ""
    t.integer  "city_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "streets", ["city_id"], :name => "index_streets_on_city_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.string   "taggable_type", :default => ""
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type"], :name => "unique_taggings", :unique => true
  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"
  add_index "taggings", ["tagger_id", "tagger_type"], :name => "index_taggings_on_tagger_id_and_tagger_type"

  create_table "tags", :force => true do |t|
    t.string  "name",    :default => ""
    t.integer "site_id"
    t.string  "link"
  end

  add_index "tags", ["name", "site_id"], :name => "index_tags_on_name_and_site_id", :unique => true
  add_index "tags", ["name"], :name => "index_tags_on_name_and_kind"
  add_index "tags", ["site_id"], :name => "index_tags_on_site_id"

  create_table "twitter_accounts", :force => true do |t|
    t.string   "login",                             :null => false
    t.string   "secret"
    t.string   "token"
    t.string   "password",                          :null => false
    t.integer  "site_rubric_id"
    t.string   "hash_tags"
    t.boolean  "active",         :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "site_id",                           :null => false
  end

  add_index "twitter_accounts", ["site_id"], :name => "index_rubric_twitters_on_site_id"
  add_index "twitter_accounts", ["site_rubric_id"], :name => "index_rubric_twitters_on_site_rubric_id"

  create_table "user_visits", :force => true do |t|
    t.integer  "user_id",                                  :null => false
    t.string   "session",                  :default => ""
    t.string   "ip",         :limit => 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_visits", ["user_id", "session"], :name => "index_user_visits_on_user_id_and_session"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "city"
    t.text     "interests"
    t.string   "icq"
    t.string   "skype"
    t.text     "about"
    t.string   "avatar"
    t.boolean  "ban",                                     :default => false,  :null => false
    t.string   "user_type",                               :default => "user", :null => false
    t.date     "birth"
    t.string   "academic"
    t.boolean  "show_icq"
    t.boolean  "show_skype"
    t.string   "confirmation_token"
    t.boolean  "confirm",                                 :default => false
    t.string   "last_name"
    t.string   "first_name"
    t.boolean  "show_email"
    t.datetime "visited_at"
    t.boolean  "notify_new_msg",                          :default => true
    t.string   "subdomain"
    t.string   "vkontakte_uid"
    t.string   "phone_number"
    t.integer  "site_id"
    t.boolean  "male"
    t.boolean  "email_notification",                      :default => true
    t.boolean  "multi_editor",                            :default => false
    t.datetime "confirmed_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "facebook_uid"
    t.string   "twitter_uid"
    t.string   "google_oauth2_uid"
    t.string   "vkontakte"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "linkedin"
    t.string   "gplus"
    t.string   "instagram"
    t.boolean  "hide_profile",                            :default => false
    t.integer  "questions_count",                         :default => 0
    t.boolean  "terms",                                   :default => false
    t.boolean  "gdpr",                                    :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["site_id"], :name => "index_users_on_site_id"
  add_index "users", ["subdomain", "site_id"], :name => "index_users_on_subdomain_and_site_id", :unique => true

  create_table "users_friends", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "friend_id"
  end

  add_index "users_friends", ["user_id", "friend_id"], :name => "index_users_friends_on_user_id_and_friend_id", :unique => true

  create_table "vacancies", :force => true do |t|
    t.integer  "user_id"
    t.text     "text"
    t.string   "money"
    t.string   "busy"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "company_name"
    t.integer  "industry_id"
    t.text     "contacts"
    t.boolean  "archive",         :default => false
    t.boolean  "approved",        :default => false
    t.datetime "approved_at"
    t.integer  "page_views",      :default => 1
    t.string   "text_hash"
    t.integer  "region_city_id"
    t.integer  "catalog_id"
    t.string   "link",            :default => ""
    t.integer  "region_id"
    t.integer  "currency"
    t.text     "description"
    t.text     "terms"
    t.text     "requirements"
    t.boolean  "hot",             :default => false
    t.text     "additional_info"
    t.boolean  "user_contacts",   :default => false
    t.string   "contacts_name"
    t.string   "contacts_email"
    t.string   "contacts_phone"
    t.datetime "posted_at"
    t.boolean  "closed",          :default => false
    t.integer  "posted_for",      :default => 30
  end

  add_index "vacancies", ["catalog_id"], :name => "index_vacancies_on_catalog_id"
  add_index "vacancies", ["industry_id"], :name => "index_vacancies_on_industry_id"
  add_index "vacancies", ["region_city_id"], :name => "index_vacancies_on_region_city_id"
  add_index "vacancies", ["region_id"], :name => "index_vacancies_on_region_id"
  add_index "vacancies", ["text_hash"], :name => "index_vacancies_on_text_hash_and_site_id", :unique => true
  add_index "vacancies", ["user_id"], :name => "index_vacancies_on_user_id"

  create_table "versions", :force => true do |t|
    t.string   "item_type",                            :null => false
    t.integer  "item_id",                              :null => false
    t.string   "event",                                :null => false
    t.string   "whodunnit"
    t.text     "object",         :limit => 2147483647
    t.datetime "created_at"
    t.integer  "site_id"
    t.text     "object_changes", :limit => 2147483647
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"
  add_index "versions", ["site_id"], :name => "index_versions_on_site_id"

  create_table "web_analytics_blocks", :force => true do |t|
    t.text     "body"
    t.integer  "site_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "code_type",  :default => ""
  end

  add_index "web_analytics_blocks", ["site_id"], :name => "index_web_analytics_blocks_on_site_id"

end
