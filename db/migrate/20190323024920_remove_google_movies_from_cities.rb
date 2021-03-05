class RemoveGoogleMoviesFromCities < ActiveRecord::Migration
  def up
    remove_column :cities, :has_google_movies
  end

  def down
    add_column :cities, :has_google_movies, :boolean, :default => false
  end
end
