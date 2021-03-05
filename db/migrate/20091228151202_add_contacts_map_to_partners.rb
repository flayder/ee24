class AddContactsMapToPartners < ActiveRecord::Migration
  def self.up
    add_column :partners, :contacts_map, :string
  end

  def self.down
    remove_column :partners, :contacts_map
  end
end
