class CreateCatalogRatings < ActiveRecord::Migration
  def self.up
    create_table :catalog_ratings do |t|
      t.integer :year, :month, :catalog_id
      t.float   :rating, :default => 0
      t.timestamps
    end
    add_index :catalog_ratings, :catalog_id
  end

  def self.down
    drop_table :catalog_ratings
  end
end
