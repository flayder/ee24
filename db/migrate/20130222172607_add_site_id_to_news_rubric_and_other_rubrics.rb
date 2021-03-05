class AddSiteIdToNewsRubricAndOtherRubrics < ActiveRecord::Migration
  def change
    add_column :news_rubrics, :site_id, :integer
    add_column :event_rubrics, :site_id, :integer
    add_column :global_rubrics, :site_id, :integer
    add_column :photo_global_rubrics, :site_id, :integer
    add_column :rubric_docs, :site_id, :integer

    add_index :news_rubrics, :site_id
    add_index :event_rubrics, :site_id
    add_index :global_rubrics, :site_id
    add_index :photo_global_rubrics, :site_id
    add_index :rubric_docs, :site_id
  end
end
