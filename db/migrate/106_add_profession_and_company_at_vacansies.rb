class AddProfessionAndCompanyAtVacansies < ActiveRecord::Migration
  def self.up
    add_column("vacancies", "new_profession", :string)
    add_column("vacancies", "company", :string)
  end

  def self.down
    remove_column("vacancies", "new_profession")
    remove_column("vacancies", "company")
  end
end
