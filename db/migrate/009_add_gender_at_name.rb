class AddGenderAtName < ActiveRecord::Migration
  def self.up
    add_column( "names", "gender" , :string, { :null => true }) 
  end

  def self.down
    remove_column("names", "gender") 
  end
end
