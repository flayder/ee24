class AddLogoToPartners < ActiveRecord::Migration
  def self.up
    add_column :partners, :image, :string
  end

  def self.down
    remove_column :partners, :image
  end
end
