class AddTitleToAdCodes < ActiveRecord::Migration
  def change
    add_column :ad_codes, :title, :string, :default => ''
  end
end
