class CreateCountriesDocs < ActiveRecord::Migration
  def self.up
    create_table :countries_docs, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :country_id,                 :integer
      t.column :doc_type,                   :string
      t.column :text,                       :text
      t.column :active,                     :boolean, :default => false, :nil => false
      t.column :main,                       :boolean, :default => false, :nil => false
      t.timestamps
    end
  end

  def self.down
    drop_table :countries_docs
  end
end
