class AddPathAtSeo < ActiveRecord::Migration
  def self.up
    add_column("seos", "path", :integer)
  end

  def self.down
    remove_column("seos", "path")
  end
end
