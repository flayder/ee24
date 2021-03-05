class CreateRubricTwitters < ActiveRecord::Migration
  def change
    create_table :rubric_twitters do |t|
      t.string :login, :null => false
      t.string :secret
      t.string :token
      t.string :password, :null => false
      t.integer :site_rubric_id
      t.string :hash_tags
      t.boolean :active, :default => false

      t.timestamps
    end

    add_index :rubric_twitters, :site_rubric_id
  end
end
