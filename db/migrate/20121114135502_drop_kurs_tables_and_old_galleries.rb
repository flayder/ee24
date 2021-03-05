class DropKursTablesAndOldGalleries < ActiveRecord::Migration
  def change
    drop_table :kurs
    drop_table :kurs_metalls
    drop_table :user_logs
  end
end
