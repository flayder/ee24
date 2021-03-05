class CreateSiteSession < ActiveRecord::Migration
  def self.up
    create_table :site_session do |t|
      t.column :user_id,                    :integer
      t.column :session,                    :string
      t.timestamps
    end
  end

  def self.down
    drop_table :site_session
  end
end
