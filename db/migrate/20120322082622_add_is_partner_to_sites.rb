class AddIsPartnerToSites < ActiveRecord::Migration
  def change
    add_column :sites, :is_partner, :boolean, :default => false
    prague = Site.find_by_domain('420on.cz')
    if prague
      prague.update_attribute(:is_partner, true)
    end
  end
end
