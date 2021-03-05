class DropLinkFromTags < ActiveRecord::Migration
  def change
    remove_column :tags, :link
  end
end
