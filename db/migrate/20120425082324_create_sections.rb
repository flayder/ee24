class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :title, :default => ''
      t.string :controller, :default => ''

      t.timestamps
    end
  end
end
