class AddMigratedToBoards < ActiveRecord::Migration
  def change
    add_column :boards, :migrated, :boolean, :default => false
  end
end
