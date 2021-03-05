class AddDirtyToReplyAndComment < ActiveRecord::Migration
  def change
    add_column :replies, :dirty, :boolean, default: false
    add_column :comments, :dirty, :boolean, default: false
  end
end
