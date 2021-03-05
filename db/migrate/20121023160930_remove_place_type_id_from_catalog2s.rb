class RemovePlaceTypeIdFromCatalog2s < ActiveRecord::Migration
  def change
    remove_column :catalog2s, :place_type_id
  end
end
