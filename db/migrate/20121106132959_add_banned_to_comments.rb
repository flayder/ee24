class AddBannedToComments < ActiveRecord::Migration
  def change
    add_column :comments, :banned, :boolean, :default => false
  end
end