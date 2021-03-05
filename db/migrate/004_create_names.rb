class CreateNames < ActiveRecord::Migration
  def self.up
    create_table :names, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :title,                      :string
      t.column :text,                       :text
      t.column :letter,                     :string
      t.column :active,                     :boolean, :default => false, :nil => false
      t.column :main,                       :boolean, :default => false, :nil => false
      t.timestamps
    end
  end

  def self.down
    drop_table :names
  end
end
