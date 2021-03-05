class ChangePathColumnInSeos < ActiveRecord::Migration
  def self.up
    change_column :seos, :path, :string
  end

  def self.down
    change_column :seos, :path, :integer
  end
end
