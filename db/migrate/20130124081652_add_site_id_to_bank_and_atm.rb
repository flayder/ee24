class AddSiteIdToBankAndAtm < ActiveRecord::Migration
  def change
    add_column :banks, :site_id, :integer
    add_column :atms, :site_id, :integer
    add_index :banks, :site_id
    add_index :atms, :site_id
  end
end
