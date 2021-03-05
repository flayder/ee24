class AddSiteIdIndexToComment < ActiveRecord::Migration
  def change
  	add_index :comments, :site_id
  end
end