class AddLinkToTagsAgain < ActiveRecord::Migration
  def change
    add_column :tags, :link, :string
  end
end
