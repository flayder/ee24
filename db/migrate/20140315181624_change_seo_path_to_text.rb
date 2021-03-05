class ChangeSeoPathToText < ActiveRecord::Migration
  def up
    change_column :seos, :path, :text
  end

  def down
    change_column :seos, :path, :string
  end
end
