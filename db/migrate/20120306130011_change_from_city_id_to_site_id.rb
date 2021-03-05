class ChangeFromCityIdToSiteId < ActiveRecord::Migration
  def up
    rename_column :boards, :city_id, :site_id
    rename_column :catalog2s, :city_id, :site_id
    rename_column :events, :city_id, :site_id
    rename_column :news_docs, :city_id, :site_id
    #rename_column :weathers, :city_id, :site_id
    rename_column :seos, :city_id, :site_id
  end

  def down
    rename_column :boards, :site_id, :city_id
    rename_column :catalog2s, :site_id, :city_id
    rename_column :events, :site_id, :city_id
    rename_column :news_docs, :site_id, :city_id
    #rename_column :weathers, :site_id, :city_id
    rename_column :seos, :site_id, :city_id
  end
end