class AddGalleriesAtCatalog < ActiveRecord::Migration
  def self.up
    create_table :catalog_galleries, :id => false do |t|
      t.column :catalog_id,       :integer
      t.column :gallery_id,       :integer
    end
  end

  def self.down
    drop_table :catalog_galleries
  end
end
