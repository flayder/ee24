class AddShowUrlAtRubricDoc < ActiveRecord::Migration
  def self.up
    add_column("rubric_docs", "show_url", :string)
  end

  def self.down
    remove_column("rubric_docs", "show_url")
  end
end
