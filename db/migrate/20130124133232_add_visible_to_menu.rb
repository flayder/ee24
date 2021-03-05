class AddVisibleToMenu < ActiveRecord::Migration
  def change
    add_column :menus, :visible, :boolean
  end
end
