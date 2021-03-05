class CreateForumsGroups < ActiveRecord::Migration
  def self.up
    create_table :forums_groups do |t|
      t.column :title,     :string
      t.column :position,  :integer
      t.timestamps
    end
    add_column( "forums", "forums_group_id" , :integer)
  end

  def self.down
    drop_table :forums_groups
    remove_column("forums", "forums_group_id")
  end
end
