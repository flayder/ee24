class CreateMainSections < ActiveRecord::Migration
  def change
    create_table :main_sections do |t|
      t.string :name
      t.string :identity
      t.boolean :active

      t.timestamps
    end
  end
end
