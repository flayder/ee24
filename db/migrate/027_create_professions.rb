class CreateProfessions < ActiveRecord::Migration
  def self.up
    create_table :professions do |t|
      t.column :title,                      :string
      t.column :vacancy_count,              :integer, :default => 0, :nil => true
      t.column :industry_id,                :integer
      t.column :active,                     :boolean, :default => false, :nil => false
      t.column :main,                       :boolean, :default => false, :nil => false
      t.timestamps
    end
  end

  def self.down
    drop_table :professions
  end
end
