class AddRecommendToCatalog < ActiveRecord::Migration
  def change
    add_column :catalogs, :recommend, :boolean, default: false
  end
end
