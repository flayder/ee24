class AddOnMainAndAnnotationAtGellary < ActiveRecord::Migration
  def self.up
    add_column("galleries", "on_main", :boolean, :default => false)
    add_column("galleries", "on_main_2", :boolean, :default => false)
    add_column("galleries", "annotation", :text)
  end

  def self.down
    remove_column("galleries", "on_main")
    remove_column("galleries", "on_main_2")
    remove_column("galleries", "annotation")
  end
end
