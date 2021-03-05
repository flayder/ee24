class CreateAccesses < ActiveRecord::Migration
  def self.up
    create_table :accesses do |t|
      t.column :user_id,                    :integer
      t.column :menu_id,                    :integer
      t.column :city_id,                    :integer
      t.column :model,                      :string
      t.column :model_id,                   :integer
    end
  end

  def self.down
    drop_table :accesses
  end
end
