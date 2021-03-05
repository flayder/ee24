class CreateDates < ActiveRecord::Migration
  def self.up
    create_table :event_dates, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :date_id,             :integer
      t.column :date_type,           :string
      t.column :date,                :date
      t.timestamps
    end
  end

  def self.down
    drop_table :event_dates
  end
end
