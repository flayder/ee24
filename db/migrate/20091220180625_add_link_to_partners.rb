class AddLinkToPartners < ActiveRecord::Migration
  def self.up
    add_column :partners, :link, :string
  end

  def self.down
    remove_column :partners, :link
  end
end
