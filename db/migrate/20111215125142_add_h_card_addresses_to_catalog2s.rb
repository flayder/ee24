class AddHCardAddressesToCatalog2s < ActiveRecord::Migration
  def self.up
  	add_column :catalog2s, :region_extension, :string
  	add_column :catalog2s, :locality, :string
  	add_column :catalog2s, :street_address, :string
  	add_column :catalog2s, :extended_address, :string
    add_column :catalog2s, :postal_code, :integer
  	add_column :catalog2s, :hcard_converted, :boolean, :default => false
  end

  def self.down
  	remove_column :catalog2s, :region_extension
  	remove_column :catalog2s, :locality
  	remove_column :catalog2s, :street_address
  	remove_column :catalog2s, :extended_address
    remove_column :catalog2s, :postal_code
  	remove_column :catalog2s, :hcard_converted
  end
end
