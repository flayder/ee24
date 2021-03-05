class AddVkontakteUidToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :vkontakte_uid, :string
  end

  def self.down
    remove_column :users, :vkontakte_uid
  end
end
