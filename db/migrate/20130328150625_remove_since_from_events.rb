class RemoveSinceFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :since
  end
end
