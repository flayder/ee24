class AddLogoToSites < ActiveRecord::Migration
  def change
    add_column :sites, :logo, :string
    #Rake::Task['sites:move_logos'].invoke
  end
end
