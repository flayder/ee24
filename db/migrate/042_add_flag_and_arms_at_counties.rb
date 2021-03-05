class AddFlagAndArmsAtCounties < ActiveRecord::Migration
  def self.up
    rename_column("countries", "image", "flag")
    add_column("countries", "arms", :string)
  end

  def self.down
    rename_column("countries", "flag", "image")
    remove_column("countries", "arms")
  end
end
