class CreateMainMenuLinks < ActiveRecord::Migration
  def change
    create_table :main_menu_links do |t|
      t.integer :site_id
      t.string :title
      t.string :path
      t.integer :position
      t.string :css_class

      t.timestamps
    end
  end
end
