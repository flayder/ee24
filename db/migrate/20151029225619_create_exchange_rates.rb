class CreateExchangeRates < ActiveRecord::Migration
  def up
    create_table :exchange_rates do |t|
      t.float :eur_czk_rate, default: 0
      t.float :usd_czk_rate, default: 0
      t.float :rub_czk_rate, default: 0
      t.date  :date_of_rate, null: false

      t.timestamps
    end
  end

  def down
    drop_table :exchange_rates
  end
end
