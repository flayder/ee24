class AddInducedTitleToCities < ActiveRecord::Migration
  def self.up
    add_column :cities, :induced_title, :string
  end

  def self.down
    remove_column :cities, :induced_title
  end
end
