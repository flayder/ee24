class AddPlaceRubricIdAtPlaces < ActiveRecord::Migration
  def self.up
    add_column("places", "place_type_id",  :integer)
    rename_column("place_types", "place_rubrics_id", "place_rubric_id")
  end

  def self.down
    remove_column("places", "place_type_id")
    rename_column("place_types", "place_rubric_id", "place_rubrics_id")
  end
end
