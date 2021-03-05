class AddMigratedToSponsorBanners < ActiveRecord::Migration
  def change
    add_column :sponsor_banners, :migrated, :boolean, :default => false
  end
end
