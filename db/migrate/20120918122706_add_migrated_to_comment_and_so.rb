class AddMigratedToCommentAndSo < ActiveRecord::Migration
  def change
  	add_column :comments, :migrated, :boolean, :default => false
  	add_column :replies, :migrated, :boolean, :default => false
  	add_column :topics, :migrated, :boolean, :default => false
  end
end