class AddAvatarMainClosedAtTopics < ActiveRecord::Migration
  def self.up
    add_column("topics", "avatar",  :string)
    add_column("topics", "closed",  :boolean)
    add_column("topics", "main",    :boolean)
  end

  def self.down
    remove_column("topics", "avatar")
    remove_column("topics", "closed")
    remove_column("topics", "main")
  end
end
