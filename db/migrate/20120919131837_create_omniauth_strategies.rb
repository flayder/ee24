class CreateOmniauthStrategies < ActiveRecord::Migration
  def change
    create_table :omniauth_strategies do |t|
      t.string :type
      t.integer :site_id
      t.text :credentials

      t.timestamps
    end

    add_index :omniauth_strategies, [:site_id, :type], :uniq => true
  end
end
