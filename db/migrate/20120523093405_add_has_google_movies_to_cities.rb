class AddHasGoogleMoviesToCities < ActiveRecord::Migration
  def change
    add_column :cities, :has_google_movies, :boolean, :default => false
  end
end
