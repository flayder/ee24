class AddSiteIdToBoardType < ActiveRecord::Migration
  def change
    add_column :board_types, :site_id, :integer
    add_index :board_types, :site_id
  end
end
