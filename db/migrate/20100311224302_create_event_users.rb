class CreateEventUsers < ActiveRecord::Migration
  def self.up
    create_table :event_users, :id => false do |t|
      t.integer :event_id
      t.integer :user_id
    end
  end

  def self.down
    drop_table :event_users
  end
end
