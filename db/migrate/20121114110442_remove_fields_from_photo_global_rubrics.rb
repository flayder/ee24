class RemoveFieldsFromPhotoGlobalRubrics < ActiveRecord::Migration
  def up
    change_table :photo_global_rubrics do |t|
      t.remove :active
      t.remove :main
      t.remove :approved
    end
  end

  def down
    change_table :photo_global_rubrics do |t|
      t.boolean :active, :default => false
      t.boolean :main, :default => false
      t.boolean :approved, :default => false
    end
  end
end
