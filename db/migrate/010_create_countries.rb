class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :title,                      :string
      t.column :active,                     :boolean, :default => false, :nil => false
      t.column :main,                       :boolean, :default => false, :nil => false
      t.column :image,                      :string
      t.timestamps
    end
  end

  def self.down
    drop_table :countries
  end
end
