class AddFaviconToSites < ActiveRecord::Migration
  def change
    add_column :sites, :favicon, :string
    #Rake::Task['sites:move_favicons'].invoke
  end
end
