class AddBannedToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :banned, :boolean, :default => false
  end
end
