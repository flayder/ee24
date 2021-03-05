class CreateForecastAnchors < ActiveRecord::Migration
  def change
    create_table :forecast_anchors do |t|
      t.string :text
      t.integer :limit
      t.integer :widget_id

      t.timestamps
    end

    add_index :forecast_anchors, :widget_id
  end
end
