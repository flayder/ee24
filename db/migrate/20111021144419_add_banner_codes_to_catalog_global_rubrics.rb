class AddBannerCodesToCatalogGlobalRubrics < ActiveRecord::Migration
  def self.up
    add_column :catalog_global_rubrics, :adriver_970x90_code, :text, :default => ''
    add_column :catalog_global_rubrics, :adriver_240x400_code, :text, :default => ''
  end

  def self.down
    remove_column :catalog_global_rubrics, :adriver_970x90_code
    remove_column :catalog_global_rubrics, :adriver_240x400_code
  end
end
