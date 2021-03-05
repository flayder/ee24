class CreateExternalDocs < ActiveRecord::Migration
  def change
    create_table :external_docs do |t|
      t.string :url
      t.string :url_name
      t.string :url_picture
      t.integer :site_id
      t.integer :user_id
      t.integer :external_doc_rubric_id
      t.integer :position
      t.boolean :approved, default: false
      t.boolean :main, default: false

      t.timestamps
    end
  end
end
