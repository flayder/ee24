class AddAdminPanelAccessToSiteAdmin < ActiveRecord::Migration
  def change
    add_column :site_admins, :admin_panel_access, :boolean, :default => false
  end
end
