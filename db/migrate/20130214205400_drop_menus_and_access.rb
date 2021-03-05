class DropMenusAndAccess < ActiveRecord::Migration
  def change
    drop_table :menus
    drop_table :accesses
  end
end
