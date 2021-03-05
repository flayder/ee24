class AddContactsAtResume < ActiveRecord::Migration
  def self.up
    add_column("resumes", "contacts", :text)
  end

  def self.down
    remove_column("resumes", "contacts")
  end
end
