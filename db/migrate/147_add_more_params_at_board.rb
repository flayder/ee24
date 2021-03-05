class AddMoreParamsAtBoard < ActiveRecord::Migration
  def self.up
    add_column("boards", "place", :string)
    add_column("boards", "name", :string)
    add_column("boards", "cost", :string)
    add_column("boards", "rooms", :integer)
    add_column("boards", "photo_1", :string)
    add_column("boards", "photo_2", :string)
    add_column("boards", "photo_3", :string)
    add_column("boards", "photo_4", :string)
    add_column("boards", "photo_5", :string)
    add_column("boards", "photo_6", :string)
  end

  def self.down
    remove_column("boards", "place")
    remove_column("boards", "name")
    remove_column("boards", "cost")
    remove_column("boards", "rooms")
    remove_column("boards", "photo_1")
    remove_column("boards", "photo_2")
    remove_column("boards", "photo_3")
    remove_column("boards", "photo_4")
    remove_column("boards", "photo_5")
    remove_column("boards", "photo_6")
  end
end
