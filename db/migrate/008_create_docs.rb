class CreateDocs < ActiveRecord::Migration
  def self.up
    create_table :docs, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :rubric_doc_id,              :integer
      t.column :title,                      :string
      t.column :annotation,                 :text
      t.column :text,                       :text
      t.column :active,                     :boolean, :default => false, :nil => false
      t.column :main,                       :boolean, :default => false, :nil => false
      t.column :image,                      :string
      t.timestamps
    end
  end

  def self.down
    drop_table :docs
  end
end
