class CreateIndustries < ActiveRecord::Migration
  def self.up
    create_table :industries do |t|
      t.column :title,                      :string
      t.column :profession_count,           :integer
      t.column :active,                     :boolean, :default => false, :nil => false
      t.column :main,                       :boolean, :default => false, :nil => false
      t.timestamps
    end
  end

  def self.down
    drop_table :industries
  end
end
