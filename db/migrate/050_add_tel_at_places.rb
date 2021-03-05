class AddTelAtPlaces < ActiveRecord::Migration
  def self.up
    add_column("places", "tel",  :string)
    
  end

  def self.down
    remove_column("places", "tel")
  end
end
