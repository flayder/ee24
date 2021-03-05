class CreateContestPartPhotos < ActiveRecord::Migration
  def self.up
    create_table :contest_part_photos do |t|
      t.string :image, :default => ''
      t.integer :contest_part_id
      
      t.timestamps
    end
    add_index :contest_part_photos, :contest_part_id
  end

  def self.down
    drop_table :contest_part_photos
  end
end
