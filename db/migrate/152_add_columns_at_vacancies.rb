class AddColumnsAtVacancies < ActiveRecord::Migration
  def self.up
    add_column("vacancies", "archive", :boolean)
    add_column("vacancies", "tel", :string)
    add_column("vacancies", "email", :string)
    add_column("vacancies", "name", :string)
    add_column("vacancies", "photo_1", :string)
  end

  def self.down
    remove_column("vacancies", "archive")
    remove_column("vacancies", "tel")
    remove_column("vacancies", "email")
    remove_column("vacancies", "name")
    remove_column("vacancies", "photo_1")
  end
end
