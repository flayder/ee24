class ModifyCatalogRubrics < ActiveRecord::Migration
  def self.up
    add_column :catalog_global_rubrics, :with_rating, :boolean, :default => false
    add_column :catalog_global_rubrics, :lft, :integer
    add_column :catalog_global_rubrics, :rgt, :integer
  end

  def self.down
    remove_column :catalog_global_rubrics, :with_rating
    remove_column :catalog_global_rubrics, :lft
    remove_column :catalog_global_rubrics, :rgt
  end
end
