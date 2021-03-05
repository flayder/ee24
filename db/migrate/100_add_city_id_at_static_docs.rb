class AddCityIdAtStaticDocs < ActiveRecord::Migration
  def self.up
    add_column("static_docs", "city_id", :integer)
  end

  def self.down
    remove_column("static_docs", "city_id")
  end
end
