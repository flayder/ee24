class AddControllerAtRubricDoc < ActiveRecord::Migration
  def self.up
    add_column("rubric_docs", "link", :string, { :null => true })
  end

  def self.down
    remove_column "rubric_docs", "link"
  end
end
