class AddRootIdAtGallery < ActiveRecord::Migration
  def self.up
    add_column("galleries", "root_id", :integer, :nil => false)
  end

  def self.down
    remove_column("galleries", "root_id")
  end
end
