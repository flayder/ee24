# encoding:utf-8
class CreateSiteForums < ActiveRecord::Migration
  def change
    create_table :site_forums do |t|
      t.integer :site_id
      t.string :title

      t.timestamps
    end

    add_index :site_forums, :site_id
  end
end
