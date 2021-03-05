class CreateForums < ActiveRecord::Migration
  def self.up
    create_table :forums, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8'  do |t|
        t.column :title,            :string
        t.column :url,              :string
        t.column :position,         :integer
    end
  end

  def self.down
    drop_table :forums
  end
end
