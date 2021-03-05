class DropCatalogsRubricsTable < ActiveRecord::Migration
  def change
    drop_table :catalog_rubrics
  end
end
