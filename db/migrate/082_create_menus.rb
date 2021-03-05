class CreateMenus < ActiveRecord::Migration
  def self.up
    create_table :menus do |t|
      t.string   "title"
      t.string   "list_url"
      t.string   "create_url"
      t.integer  "level", :nil => false, :default => 0
      t.string   "element_type"

      t.integer  "parent_id", :nil => false, :default => 0
      t.integer  "position", :nil => false, :default => 0

      t.string   "model"
      t.string   "model_id"
    end
  end

  def self.down
    drop_table :menus
  end
end
