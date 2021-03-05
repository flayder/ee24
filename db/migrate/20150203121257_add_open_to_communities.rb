class AddOpenToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :open, :boolean, default: true
  end
end
