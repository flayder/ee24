class AddGmapsToAtms < ActiveRecord::Migration
  def change
    add_column :atms, :gmaps, :boolean
  end
end
