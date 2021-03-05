class DropTablePlaceTypes < ActiveRecord::Migration
  def change
    drop_table :place_types
  end
end
