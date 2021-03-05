class AddSiteIdToDocs < ActiveRecord::Migration
  def change
    add_column :docs, :site_id, :integer
    add_index :docs, :site_id
  end
end
