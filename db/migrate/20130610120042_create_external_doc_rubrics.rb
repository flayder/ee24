class CreateExternalDocRubrics < ActiveRecord::Migration
  def change
    create_table :external_doc_rubrics do |t|
      t.string :title
      t.integer :site_id
      t.integer :position

      t.timestamps
    end
  end
end
