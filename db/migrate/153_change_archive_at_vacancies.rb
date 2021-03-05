class ChangeArchiveAtVacancies < ActiveRecord::Migration
  def self.up
    remove_column("vacancies", "archive")
    add_column("vacancies", "archive", :boolean, :default => false)
  end

  def self.down
    remove_column("vacancies", "archive")
    add_column("vacancies", "archive", :boolean)
  end
end
