class AddLatitudeAndLongitudeToAtms < ActiveRecord::Migration
  def up
    change_table :atms do |t|
      t.string :latitude
      t.string :longitude
    end
  end

  def down
    change_table :atms do |t|
      t.remove :latitude
      t.remove :longitude
    end
  end
end
