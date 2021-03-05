class AddExpertAndBestToReplies < ActiveRecord::Migration
  def change
    add_column :replies, :expert, :boolean, :default => false
    add_column :replies, :best, :boolean, :default => false
  end
end
