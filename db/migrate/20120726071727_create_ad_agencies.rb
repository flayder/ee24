class CreateAdAgencies < ActiveRecord::Migration
  def change
    create_table :ad_agencies do |t|
      t.string :title, :default => ''

      t.timestamps
    end
  end
end
