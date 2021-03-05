class RemoveCinemaFromEvent < ActiveRecord::Migration
  def self.up
    remove_column("events", "stars")
    remove_column("events", "cinema_about")
    remove_column("events", "cinema_director")
    remove_column("events", "cinema_actors")
  end

  def self.down
    add_column("events", "stars", :integer)
    add_column("events", "cinema_about", :string)
    add_column("events", "cinema_director", :string)
    add_column("events", "cinema_actors", :string)
  end
end
