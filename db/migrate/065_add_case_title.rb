class AddCaseTitle < ActiveRecord::Migration
  def self.up
    add_column("countries", "case_title",  :string)
  end

  def self.down
    remove_column("countries", "case_title")
  end
end
