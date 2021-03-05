class CreateCatalogGlobalRubrics < ActiveRecord::Migration
  def self.up
    create_table :catalog_global_rubrics, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string   "title"
      t.string   "link"
      t.integer  "position"
      t.integer  "parent_id"
      t.boolean  "main"
      t.boolean  "active"
      t.integer  "counter",              :default => 0,    :null => false
      t.integer  "all_children_counter", :default => 0,    :null => false
      t.boolean  "approved",             :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :catalog_global_rubrics
  end
end
