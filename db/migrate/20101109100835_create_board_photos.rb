class CreateBoardPhotos < ActiveRecord::Migration
  def self.up
    create_table :board_photos do |t|
      t.integer :photoable_id
      t.string  :photoable_type
      t.string  :image
      t.timestamps
    end
  end

  def self.down
    drop_table :board_photos
  end
end
