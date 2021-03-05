class AddPositionMainAndDescriptionToEventRubric < ActiveRecord::Migration
  def change
    add_column :event_rubrics, :afisha_main, :boolean, default: true
    add_column :event_rubrics, :afisha_main_position, :integer
    add_column :event_rubrics, :description, :text
  end
end
