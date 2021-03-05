class AddUserAddedFlagToRubricDocs < ActiveRecord::Migration
  def self.up
    add_column :global_rubrics, :user_added, :boolean, :default => false
    add_column :rubric_docs, :user_added, :boolean, :default => false
  end

  def self.down
    remove_column :global_rubrics, :user_added
    remove_column :rubric_docs, :user_added
  end
end
