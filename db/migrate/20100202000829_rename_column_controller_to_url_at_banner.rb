class RenameColumnControllerToUrlAtBanner < ActiveRecord::Migration
  def self.up
    rename_column "banners", "controller", "link"
  end

  def self.down
    rename_column "banners", "link", "controller"
  end
end
