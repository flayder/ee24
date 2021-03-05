class AddSiteIdToStaticDocs < ActiveRecord::Migration
  def change
    add_column :static_docs, :site_id, :integer, :null => false
    add_index :static_docs, :site_id
  end
end