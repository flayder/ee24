class AddForumsCountToForumsGroups < ActiveRecord::Migration
  def change
    add_column :forums_groups, :forums_count, :integer, :default => 0
  end
end
