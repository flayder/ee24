class RmProfessionIdAndAddIndustryId < ActiveRecord::Migration
  def self.up
    remove_column("vacancies", "profession_id")
    remove_column("vacancies", "new_profession")
    add_column("vacancies", "industry_id", :integer)
  end

  def self.down
    add_column("vacancies", "profession_id", :integer)
    add_column("vacancies", "new_profession", :string)
    remove_column("vacancies", "industry_id")
  end
end
