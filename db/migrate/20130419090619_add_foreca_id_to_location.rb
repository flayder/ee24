class AddForecaIdToLocation < ActiveRecord::Migration
  def change
    add_column :forecast_locations, :foreca_id, :string
    add_index :forecast_locations, :foreca_id
  end
end
