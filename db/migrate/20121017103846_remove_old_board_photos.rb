class RemoveOldBoardPhotos < ActiveRecord::Migration
  def up
    change_table :boards do |t|
      t.remove :photo_1
      t.remove :photo_2
      t.remove :photo_3
      t.remove :photo_4
      t.remove :photo_5
      t.remove :photo_6
    end
  end

  def down
    change_table :boards do |t|
      t.string :photo_1
      t.string :photo_2
      t.string :photo_3
      t.string :photo_4
      t.string :photo_5
      t.string :photo_6
    end
  end
end
