class AddDefaultValueForMenuVisible < ActiveRecord::Migration
  def change
    change_column :menus, :visible, :boolean, :default => true
  end
end
