class CreateStaticDocs < ActiveRecord::Migration
  def self.up
    create_table :static_docs do |t|
      t.column :title,                      :string
      t.column :text,                       :text
      t.column :active,                     :boolean, :default => false, :nil => false
      t.column :main,                       :boolean, :default => false, :nil => false
      t.column :link,                       :string
      t.timestamps
    end
  end

  def self.down
    drop_table :static_docs
  end
end
