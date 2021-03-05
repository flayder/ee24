class DropWithRatingCatalogFields < ActiveRecord::Migration
  def change
    remove_column :catalogs, :with_rating
    remove_column :catalog_global_rubrics, :with_rating
  end
end
