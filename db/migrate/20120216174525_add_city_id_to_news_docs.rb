class AddCityIdToNewsDocs < ActiveRecord::Migration
  def self.up
    change_table :news_docs do |t|
      t.integer :city_id, :default => City.voronezh_id
      t.rename :city, :news_doc_type
    end
    add_index :news_docs, :city_id
  end

  def self.down
    change_table :news_docs do |t|
      t.remove :city_id
      t.rename :news_doc_type, :city
    end
  end
end
