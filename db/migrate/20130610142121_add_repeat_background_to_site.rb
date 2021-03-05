class AddRepeatBackgroundToSite < ActiveRecord::Migration
  def change
    add_column :sites, :repeat_background, :boolean, default: true
  end
end
