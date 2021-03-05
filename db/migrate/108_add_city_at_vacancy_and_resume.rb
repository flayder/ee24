class AddCityAtVacancyAndResume < ActiveRecord::Migration
  def self.up
    add_column("vacancies", "city_id", :integer)
    add_column("resumes", "city_id", :integer)
  end

  def self.down
    remove_column("vacancies", "city_id")
    remove_column("resumes", "city_id")
  end
end
