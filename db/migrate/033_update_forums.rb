class UpdateForums < ActiveRecord::Migration
  def self.up
    add_column( "forums", "created_at" , :datetime, {:null => true })
    add_column( "forums", "updated_at" , :datetime, { :null => true })
    add_column( "forums", "annotation" , :text, { :null => true })
  end

  def self.down
    remove_column("forums", "created_at")
    remove_column("forums", "updated_at")
    remove_column("forums", "annotation")
  end
end