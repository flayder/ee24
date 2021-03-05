class DropTablesUsersAndOldHoroscopes < ActiveRecord::Migration
  def change
    drop_table :old_horoscopes
    drop_table :old_horoscope_types
    drop_table :old_horoscope_dailies
  end
end
