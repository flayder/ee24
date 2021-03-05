class AddSiteIdToRubricTwitters < ActiveRecord::Migration
  def change
    add_column :rubric_twitters, :site_id, :integer, :null => false
    add_index :rubric_twitters, :site_id
  end
end
