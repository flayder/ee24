class CreateDesignTemplates < ActiveRecord::Migration
  def change
    create_table :design_templates do |t|
      t.string :name
      t.text :body
      t.integer :site_id

      t.timestamps
    end

    add_index :design_templates, :site_id
    add_index :design_templates, [:name, :site_id], unique: true
  end
end
