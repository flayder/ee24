class DropSiteSessions < ActiveRecord::Migration
  def change
    drop_table :site_session
  end
end
