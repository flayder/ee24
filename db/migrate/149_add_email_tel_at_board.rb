class AddEmailTelAtBoard < ActiveRecord::Migration
  def self.up
    add_column("boards", "email", :string)
    add_column("boards", "tel", :string)
  end

  def self.down
    remove_column("boards", "email")
    remove_column("boards", "tel")
  end
end
