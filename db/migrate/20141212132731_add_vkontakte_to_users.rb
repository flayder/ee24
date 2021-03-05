class AddVkontakteToUsers < ActiveRecord::Migration
  def change
    add_column :users, :vkontakte, :string
  end
end
