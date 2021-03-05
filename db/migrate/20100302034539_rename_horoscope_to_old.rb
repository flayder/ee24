class RenameHoroscopeToOld < ActiveRecord::Migration
  def self.up
    rename_table :horoscopes, "old_horoscopes"
    rename_table :horoscope_dailies, "old_horoscope_dailies"
    rename_table :horoscope_types, "old_horoscope_types"
  end

  def self.down
    rename_table "old_horoscopes", :horoscopes
    rename_table "old_horoscope_dailies", :horoscope_dailies
    rename_table "old_horoscope_types", :horoscope_types
  end
end
