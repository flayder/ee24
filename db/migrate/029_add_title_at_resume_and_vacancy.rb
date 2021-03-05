class AddTitleAtResumeAndVacancy < ActiveRecord::Migration
  def self.up
    add_column("vacancies", "title", :string) 
    add_column("resumes", "title", :string) 
  end

  def self.down
    remove_column "vacancies", "title"  
    remove_column "resumes", "title"  
  end
end
