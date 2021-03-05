class CreateSiteRubricRubricTwitters < ActiveRecord::Migration
  def change
    create_table :site_rubric_rubric_twitters do |t|
      t.integer :site_rubric_id
      t.integer :rubric_twitter_id
      t.integer :site_id

      t.timestamps
    end

    add_index :site_rubric_rubric_twitters, :site_id
    add_index :site_rubric_rubric_twitters, [:site_rubric_id, :rubric_twitter_id, :site_id], :uniq => true, :name => 'site_rubric_rubric_twitters_uniq_ids'
  end
end