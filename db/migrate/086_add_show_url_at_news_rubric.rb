class AddShowUrlAtNewsRubric < ActiveRecord::Migration
  def self.up
    add_column("news_rubrics", "show_url", :string)
  end

  def self.down
    remove_column("news_rubrics", "show_url")
  end
end
