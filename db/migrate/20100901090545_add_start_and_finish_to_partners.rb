class AddStartAndFinishToPartners < ActiveRecord::Migration
  def self.up
    add_column :partners, :start, :datetime
    add_column :partners, :finish, :datetime
  end

  def self.down
    remove_column :partners, :start
    remove_column :partners, :finish
  end
end
