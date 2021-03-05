class AddParamToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :param, :string
  end

  def self.down
    remove_column :events, :param
  end
end
