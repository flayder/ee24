class RenameColumnsAtObjectAuthor < ActiveRecord::Migration
  def self.up
    rename_column :object_authors, :model, :object_author_type
    rename_column :object_authors, :model_id, :object_author_id
  end

  def self.down
    rename_column :object_authors, :object_author_type, :model
    rename_column :object_authors, :object_author_id, :model_id
  end
end