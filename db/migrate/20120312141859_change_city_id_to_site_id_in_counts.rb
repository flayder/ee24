class ChangeCityIdToSiteIdInCounts < ActiveRecord::Migration
  def up
    rename_column :counts, :city_id, :site_id
  end

  def down
    rename_column :counts, :site_id, :city_id
  end
end
