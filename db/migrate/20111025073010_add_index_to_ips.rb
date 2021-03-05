class AddIndexToIps < ActiveRecord::Migration
  def self.up
    add_index :ips, :ip_object_id
  end

  def self.down
    remove_index :ips, :ip_object_id
  end
end
