class AddLogoAtPlaces < ActiveRecord::Migration
  def self.up
    add_column("places", "logo",  :string)
  end

  def self.down
    remove_column("places", "logo")
  end
end
