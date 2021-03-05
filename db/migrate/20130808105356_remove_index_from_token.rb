class RemoveIndexFromToken < ActiveRecord::Migration
  def up
    remove_index :mobile_devices, :token
    add_index :mobile_devices, [:site_id, :token], unique: true
  end

  def down
    add_index :mobile_devices, :token, unique: true
    remove_index :mobile_devices, [:site_id, :token]
  end
end
