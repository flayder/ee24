class AddItemsAtEvents < ActiveRecord::Migration
  def self.up
        add_column("events", "start_date", :datetime)
        add_column("events", "finish_date", :datetime)
        add_column("events", "stars", :integer)
        add_column("events", "cinema_about", :string)
        add_column("events", "cinema_director", :string)
        add_column("events", "cinema_actors", :string)
  end

  def self.down
      remove_column("events", "start_date")
      remove_column("events", "finish_date")
      remove_column("events", "stars")
      remove_column("events", "cinema_about")
      remove_column("events", "cinema_director")
      remove_column("events", "cinema_actors")
  end
end
