class CreatePlaceDocs < ActiveRecord::Migration
  def self.up
    create_table :place_docs do |t|
      t.column :place_id,                   :integer
      t.column :title,                      :string
      t.column :text,                       :text
      t.column :active,                     :boolean, :default => false, :nil => false
      t.column :main,                       :boolean, :default => false, :nil => false
      t.timestamps
    end
  end

  def self.down
    drop_table :place_docs
  end
end