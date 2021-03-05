class CreateUserVisits < ActiveRecord::Migration
  def self.up
    create_table :user_visits do |t|
      t.integer :user_id, :null => false
      t.string :session, :default => ''
      t.string :ip, :limit => 30
      
      t.timestamps
    end
    add_index :user_visits, [:user_id, :session]
  end

  def self.down
    drop_table :user_visits
  end
end
