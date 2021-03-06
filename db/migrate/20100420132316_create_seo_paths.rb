class CreateSeoPaths < ActiveRecord::Migration
  def self.up
    create_table :seo_paths do |t|
      t.string :url
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :seo_paths
  end
end
