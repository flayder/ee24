class AddDefaultDocToStaticDocs < ActiveRecord::Migration
  def self.up
    add_column :partner_static_docs, :default, :boolean
  end

  def self.down
    remove_column :partner_static_docs, :default
  end
end
