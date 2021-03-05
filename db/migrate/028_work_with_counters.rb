class WorkWithCounters < ActiveRecord::Migration
  def self.up
    add_column("professions", "resumes_count", :integer, { :null => false, :default => 0 }) 
    remove_column "industries", "profession_count" 
  end

  def self.down
    add_column("industries", "profession_count", :integer, { :null => false, :default => 0 }) 
    remove_column "professions", "resume_count" 
  end
end
