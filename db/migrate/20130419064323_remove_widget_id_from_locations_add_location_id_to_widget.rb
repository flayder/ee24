class RemoveWidgetIdFromLocationsAddLocationIdToWidget < ActiveRecord::Migration
  def change
    remove_column :forecast_anchors, :widget_id
    add_column :forecast_widgets, :anchor_id, :integer
    add_index :forecast_widgets, :anchor_id
  end
end
