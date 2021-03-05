class DropSeoPathTable < ActiveRecord::Migration
  def change
    drop_table :seo_paths
  end
end
