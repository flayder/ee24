class AddSeoTextToSeos < ActiveRecord::Migration
  def self.up
    add_column :seos, :text, :text
  end

  def self.down
    remove_column :seos, :text
  end
end
