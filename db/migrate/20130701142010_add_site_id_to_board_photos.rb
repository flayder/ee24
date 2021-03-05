class AddSiteIdToBoardPhotos < ActiveRecord::Migration
  def change
    add_column :board_photos, :site_id, :integer
  end
end
