class AddIndustryAndRmProfessionIdFromResumes < ActiveRecord::Migration
  def self.up
    remove_column("resumes", "profession_id")
    add_column("resumes", "industry_id", :integer)
  end

  def self.down
    add_column("resumes", "profession_id", :integer)
    remove_column("resumes", "industry_id")
  end
end
