class CreateUserLogs < ActiveRecord::Migration
  def self.up
    create_table :user_logs, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :user_id,        :integer
      t.column :controller,     :string
      t.column :visited_at,     :datetime
    end
    
    add_column("users", "visited_at", :datetime)
  end

  def self.down
    drop_table :user_logs
    remove_column("users", "visited_at")
  end
end
