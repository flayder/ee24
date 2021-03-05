class RenameGalleryCityIdToSiteId < ActiveRecord::Migration
  def up
    rename_column :galleries, :city_id, :site_id
  end

  def down
    rename_column :galleries, :site_id, :city_id
  end
end
