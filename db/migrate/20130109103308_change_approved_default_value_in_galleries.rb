class ChangeApprovedDefaultValueInGalleries < ActiveRecord::Migration
  def change
    change_column :galleries, :approved, :boolean, :default => false
  end
end
