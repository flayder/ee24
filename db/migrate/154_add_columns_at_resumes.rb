class AddColumnsAtResumes < ActiveRecord::Migration
  def self.up
    add_column("resumes", "archive", :boolean, :default => false)
    add_column("resumes", "tel", :string)
    add_column("resumes", "email", :string)
    add_column("resumes", "name", :string)
    add_column("resumes", "photo_1", :string)
  end

  def self.down
    remove_column("resumes", "archive")
    remove_column("resumes", "tel")
    remove_column("resumes", "email")
    remove_column("resumes", "name")
    remove_column("resumes", "photo_1")
  end
end
