class AddTitleAtCountriesDoc < ActiveRecord::Migration
  def self.up
    add_column("countries_docs", "title", :string)
  end

  def self.down
    remove_column("countries_docs", "title")
  end
end
