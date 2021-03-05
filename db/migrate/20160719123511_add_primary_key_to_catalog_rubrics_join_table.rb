class AddPrimaryKeyToCatalogRubricsJoinTable < ActiveRecord::Migration
  def change
    add_column :catalog_join_rubrics, :id, :primary_key
  end
end
