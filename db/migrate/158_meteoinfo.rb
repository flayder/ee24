class Meteoinfo < ActiveRecord::Migration
  def self.up
    create_table "meteoinfos", :force => true do |t|
      t.integer "city_id"
      t.string  "city_name"
      t.string  "city_country"
      t.string  "city_region"
      t.integer "tday"
      t.integer "tnight"
      t.integer "prec"
      t.integer "prec_prob"
      t.integer "wind_dir"
      t.integer "windspeed"
      t.string  "weather_conditions"
      t.integer "pday"
      t.integer "pnight"
      t.date    "date"
    end
  end

  def self.down
    drop_table :meteoinfos
  end
end
