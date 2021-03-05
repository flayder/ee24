class CreatePlaces < ActiveRecord::Migration
  def self.up
    create_table :places do |t|
      t.column :title,          :string
      t.column :annotation,     :text
      t.column :text,           :text
      
      t.column :email,          :string
      t.column :site,           :string
      t.column :adress,         :string
      t.column :contact,        :text
      
      t.column :star,           :integer
      
      t.column :up,             :boolean
      t.column :position,       :integer
      
      t.column :main,           :boolean
      t.column :active,         :boolean
      
      t.timestamps
    end
  end

  def self.down
    drop_table :places
  end
end
