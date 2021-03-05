class CreatePlaceTypes < ActiveRecord::Migration
  def self.up
    create_table :place_types do |t|
      t.column :title,            :string
      t.column :link,             :string
      t.column :image,            :string
      t.column :position,         :integer
      t.column :place_rubrics_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :place_types
  end
end
