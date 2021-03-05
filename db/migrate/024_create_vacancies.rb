class CreateVacancies < ActiveRecord::Migration
  def self.up
    create_table :vacancies do |t|
      t.column :profession_id,              :integer
      t.column :user_id,                    :integer
      t.column :text,                       :text
      t.column :money,                      :string
      t.column :busy,                       :string
      t.column :active,                     :boolean, :default => false, :nil => false
      t.column :main,                       :boolean, :default => false, :nil => false
      t.timestamps
    end
  end

  def self.down
    drop_table :vacancies
  end
end
