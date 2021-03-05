class AddFaxAtPlaces < ActiveRecord::Migration
  def self.up
    add_column("places", "fax",  :string)
  end

  def self.down
    remove_column("places", "fax")
  end
end
