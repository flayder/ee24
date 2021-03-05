class CreateDesignStylesheets < ActiveRecord::Migration
  def change
    create_table :design_stylesheets do |t|
      t.string :name
      t.text :body
      t.integer :site_id

      t.timestamps
    end

    add_index :design_stylesheets, :site_id
    add_index :design_stylesheets, [:name, :site_id], unique: true
  end
end
