class CreateMobileDevices < ActiveRecord::Migration
  def change
    create_table :mobile_devices do |t|
      t.string :token
      t.string :site_id

      t.timestamps
    end

    add_index :mobile_devices, :token, unique: true
  end
end
