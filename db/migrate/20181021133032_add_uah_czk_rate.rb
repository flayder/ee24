class AddUahCzkRate < ActiveRecord::Migration
  def change
    add_column :exchange_rates, :uah_czk_rate, :float, default: 0
  end
end
