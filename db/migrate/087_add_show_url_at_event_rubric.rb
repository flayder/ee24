class AddShowUrlAtEventRubric < ActiveRecord::Migration
  def self.up
    add_column("event_rubrics", "show_url", :string)
  end

  def self.down
    remove_column("event_rubrics", "show_url")
  end
end
