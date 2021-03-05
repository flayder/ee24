class AddSiteIdToSponsorBanners < ActiveRecord::Migration
  def change
    add_column :sponsor_banners, :site_id, :integer
    add_index :sponsor_banners, :site_id
  end
end
