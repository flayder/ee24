class RenameBannersToSponsors < ActiveRecord::Migration
  def change
    rename_table :banners, :sponsor_banners
    rename_column :docs, :skip_banner, :skip_sponsor_banner
  end
end