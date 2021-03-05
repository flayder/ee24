class CreateTableObjectProfession < ActiveRecord::Migration
  def self.up
    create_table :profession_objects do |t|
      t.column :profession_id,                      :integer
      t.column :vacancy_id,                         :integer
      t.column :resume_id,                          :integer
      t.timestamps
    end
    
    remove_column("profession_objects", "id")
  end

  def self.down
    drop_table :catalog_rubrics
  end
end
