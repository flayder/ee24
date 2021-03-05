class AddCompanyIdAndContactsAtVacancy < ActiveRecord::Migration
  def self.up
    add_column("vacancies", "company_id", :integer)
    add_column("vacancies", "contacts", :text)
  end

  def self.down
    remove_column("vacancies", "company_id")
    remove_column("vacancies", "contacts")
  end
end
