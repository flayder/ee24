class AddRoleToSiteAdmins < ActiveRecord::Migration
  def change
    add_column :site_admins, :role, :string, :default => ''
  end
end
