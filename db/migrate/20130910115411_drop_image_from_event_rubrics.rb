class DropImageFromEventRubrics < ActiveRecord::Migration
  def change
    remove_column :event_rubrics, :image
  end
end
