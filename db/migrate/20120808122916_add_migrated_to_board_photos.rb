class AddMigratedToBoardPhotos < ActiveRecord::Migration
  def change
    add_column :board_photos, :migrated, :boolean, :default => false
  end
end
