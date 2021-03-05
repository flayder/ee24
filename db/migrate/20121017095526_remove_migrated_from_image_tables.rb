class RemoveMigratedFromImageTables < ActiveRecord::Migration
  def up
   # remove_column :board_photos, :migrated
    remove_column :catalog2s, :migrated
    remove_column :comments, :migrated
    remove_column :topics, :migrated
    remove_column :replies, :migrated
    remove_column :banks, :migrated
    remove_column :bank_card_types, :migrated
    remove_column :users, :migrated
    remove_column :docs, :migrated
    remove_column :news_docs, :migrated
    remove_column :events, :migrated
    remove_column :photos, :migrated
    remove_column :sponsor_banners, :migrated
    remove_column :sites, :migrated
    remove_column :ad_surfaces, :migrated
    remove_column :boards, :migrated
  end

  def down
    add_column :board_photos, :migrated, :boolean, :default => false
    add_column :catalog2s, :migrated, :boolean, :default => false
    add_column :comments, :migrated, :boolean, :default => false
    add_column :topics, :migrated, :boolean, :default => false
    add_column :replies, :migrated, :boolean, :default => false
    add_column :banks, :migrated, :boolean, :default => false
    add_column :bank_card_types, :migrated, :boolean, :default => false
    add_column :users, :migrated, :boolean, :default => false
    add_column :docs, :migrated, :boolean, :default => false
    add_column :news_docs, :migrated, :boolean, :default => false
    add_column :events, :migrated, :boolean, :default => false
    add_column :photos, :migrated, :boolean, :default => false
    add_column :sponsor_banners, :migrated, :boolean, :default => false
    add_column :sites, :migrated, :boolean, :default => false
    add_column :as_surfaces, :migrated, :boolean, :default => false
    add_column :boards, :migrated, :boolean, :default => false
  end
end
