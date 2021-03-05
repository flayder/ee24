class AddPositionToEventRubrics < ActiveRecord::Migration
  def change
    add_column :event_rubrics, :position, :integer
  end
end
