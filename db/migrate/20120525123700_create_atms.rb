class CreateAtms < ActiveRecord::Migration
  def change
    create_table :atms do |t|
      t.string  :title, :default => ''
      t.integer :street_id
      t.string  :address, :default => ''
      t.string  :schedule, :default => ''

      t.timestamps
    end
    add_index :atms, :street_id
  end
end
