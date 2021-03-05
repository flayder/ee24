class AddSubTextToSeos < ActiveRecord::Migration
  TABLE_NAME = :seos

  def self.up
    add_column TABLE_NAME, "sub_text", :text
  end

  def self.down
    remove_column TABLE_NAME, "sub_text"
  end
end
