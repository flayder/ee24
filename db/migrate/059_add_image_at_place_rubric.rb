class AddImageAtPlaceRubric < ActiveRecord::Migration
  def self.up
    add_column("place_rubrics", "image",  :string)
  end

  def self.down
    remove_column("place_rubrics", "image")
  end
end
