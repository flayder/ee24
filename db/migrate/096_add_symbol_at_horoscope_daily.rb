class AddSymbolAtHoroscopeDaily < ActiveRecord::Migration
  def self.up
    add_column("horoscope_dailies", "symbol", :string, :nil => true)
  end

  def self.down
    remove_column("horoscope_dailies", "symbol")
  end
end
