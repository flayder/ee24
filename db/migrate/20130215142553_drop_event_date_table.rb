class DropEventDateTable < ActiveRecord::Migration
  def change
    drop_table :event_dates
  end
end
