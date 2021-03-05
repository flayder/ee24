class CreateGlobalRubrics < ActiveRecord::Migration
  def self.up
    create_table :global_rubrics do |t|
      t.column :title,      :string
      t.column :link,       :string
      t.timestamps
    end
    
    add_column("rubric_docs", "global_rubric_id", :integer)
  end

  def self.down
    drop_table :global_rubrics
    remove_column("rubric_docs", "global_rubric_id")
  end
end
