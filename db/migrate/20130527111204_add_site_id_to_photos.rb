class AddSiteIdToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :site_id, :integer
    add_index :photos, :site_id
  end
end
