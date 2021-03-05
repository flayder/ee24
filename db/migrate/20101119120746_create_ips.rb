class CreateIps < ActiveRecord::Migration
  def self.up
    create_table :ips do |t|
      t.string :ip, :limit => 30, :default => ''
      t.integer :ip_object_id
      t.string :ip_object_type
      t.timestamps
    end
  end

  def self.down
    drop_table :ips
  end
end
