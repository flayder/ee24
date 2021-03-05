class AddIndexToMainMenuLinks < ActiveRecord::Migration
  def change
    add_index :main_menu_links, :site_id
  end
end
