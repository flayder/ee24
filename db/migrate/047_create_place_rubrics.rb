class CreatePlaceRubrics < ActiveRecord::Migration
  def self.up
    create_table :place_rubrics do |t|
      t.column :title,          :string
      t.column :link,           :string
      t.timestamps
    end
  end

  def self.down
    drop_table :place_rubrics
  end
end
