class RenameRubricTwittersAndMakeItPolymorphic < ActiveRecord::Migration
  def change
    add_column :site_rubric_rubric_twitters, :rubric_id, :integer
    add_column :site_rubric_rubric_twitters, :rubric_type, :string
    rename_table :rubric_twitters, :twitter_accounts
    rename_table :site_rubric_rubric_twitters, :rubric_twitters
  end
end
