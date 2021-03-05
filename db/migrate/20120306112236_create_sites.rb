class CreateSites < ActiveRecord::Migration
  def up
    create_table :sites do |t|
      t.string :portal_title, :default => ''
      t.string :domain, :default => ''
      t.integer :city_id

      t.timestamps
    end
    add_index :sites, :city_id
  end

  def down
    drop_table :sites
  end
end
