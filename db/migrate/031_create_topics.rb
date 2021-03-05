class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
        t.column :forum_id,         :integer
        t.column :user_id,           :integer
        
        t.column :title,               :string
        t.column :text,               :text 
        
        t.column :created_at,       :datetime
        t.column :updated_at,       :datetime
    end
  end

  def self.down
    drop_table :topics
  end
end
