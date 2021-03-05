class RemoveUrlFromForums < ActiveRecord::Migration
  def change
    remove_column :forums, :url
  end
end
