class AddMainToPartnerStaticDocs < ActiveRecord::Migration
  def self.up
    add_column :partner_static_docs, :main, :boolean, :default => false
  end

  def self.down
    remove_column :partner_static_docs, :main
  end
end
