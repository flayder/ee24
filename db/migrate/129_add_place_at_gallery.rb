class AddPlaceAtGallery < ActiveRecord::Migration
  def self.up
    add_column("galleries", "place", :string)
  end

  def self.down
    remove_column("galleries", "place")
  end
end
