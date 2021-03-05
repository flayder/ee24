class DropPlacesTablesAndAccessCityId < ActiveRecord::Migration
  def change
    drop_table :place_docs
    drop_table :places
    drop_table :place_rubrics
    drop_table :old_news

    remove_column :accesses, :city_id
  end
end