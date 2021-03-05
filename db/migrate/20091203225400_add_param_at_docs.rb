class AddParamAtDocs < ActiveRecord::Migration
  def self.up
    add_column :docs, :param, :string
  end

  def self.down
    remove_column :docs, :param
  end
end
