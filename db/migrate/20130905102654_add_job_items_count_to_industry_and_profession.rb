class AddJobItemsCountToIndustryAndProfession < ActiveRecord::Migration
  def change
    add_column :industries, :job_items_count, :integer, default: 0
    add_column :professions, :job_items_count, :integer, default: 0
  end
end
