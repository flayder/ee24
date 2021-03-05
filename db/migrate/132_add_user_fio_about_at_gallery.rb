class AddUserFioAboutAtGallery < ActiveRecord::Migration
  def self.up
    add_column("galleries", "user_fio", :string)
    add_column("galleries", "user_about", :string)
  end

  def self.down
    remove_column("galleries", "fio")
    remove_column("galleries", "user_about")
  end
end
