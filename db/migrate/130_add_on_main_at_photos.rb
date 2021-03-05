class AddOnMainAtPhotos < ActiveRecord::Migration
  def self.up
    add_column("photos", "on_main", :boolean, :default => false)
  end

  def self.down
    remove_column("photos", "on_main")
  end
end
