class AddSkipSponsorBannerToNewsDocs < ActiveRecord::Migration
  def change
    add_column :news_docs, :skip_sponsor_banner, :boolean, :default => false
  end
end
