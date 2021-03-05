class RemoveCityIdFromStaticDocs < ActiveRecord::Migration
  def change
    remove_column :static_docs, :city_id
  end
end