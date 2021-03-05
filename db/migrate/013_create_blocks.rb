class CreateBlocks < ActiveRecord::Migration
  def self.up
    create_table :blocks, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :controller,                 :string
      t.column :title,                      :string
      t.column :up_title,                   :string
      t.column :up_link,                    :string
      t.column :annotation,                 :text
      t.column :text,                       :text
      t.column :down_title,                 :string
      t.column :down_link,                  :string
      t.column :image,                      :string
      t.column :position,                   :integer
      t.column :active,                     :boolean, :default => false, :nil => false
      t.column :main,                       :boolean, :default => false, :nil => false
      t.timestamps
    end
  end

  def self.down
    drop_table :blocks
  end
end
