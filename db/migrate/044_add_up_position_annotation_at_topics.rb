class AddUpPositionAnnotationAtTopics < ActiveRecord::Migration
  def self.up
    add_column("topics", "annotation",  :string)
    add_column("topics", "position",  :integer, :default => 0)
    add_column("topics", "up",  :boolean, :default => false)
  end

  def self.down
    remove_column("topics", "annotation")
    remove_column("topics", "position")
    remove_column("topics", "up")
  end
end
