class CreateCatalogsCatalogRubricsJoinTable < ActiveRecord::Migration
  def up
    create_table :catalog_join_rubrics, :id => false do |t|
      t.integer :catalog_id
      t.integer :catalog_rubric_id
    end
    add_index :catalog_join_rubrics, [:catalog_id, :catalog_rubric_id]

    say "migrate existing data..."
    Catalog.all.each do |catalog|
      catalog.rubrics << CatalogRubric.where(id: catalog.catalog_rubric_id)
    end
    remove_column :catalogs, :catalog_rubric_id
  end

  def down
    add_column :catalogs, :catalog_rubric_id, :integer
    Catalog.all.each do |catalog|
      catalog.catalog_rubric_id = catalog.rubrics.last.id if catalog.rubrics.present?
    end
    drop_table :catalog_join_rubrics
  end
end
