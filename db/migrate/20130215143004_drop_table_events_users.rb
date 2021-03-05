class DropTableEventsUsers < ActiveRecord::Migration
  def change
    drop_table :event_users
  end
end
