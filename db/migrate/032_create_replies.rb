class CreateReplies < ActiveRecord::Migration
  def self.up
    create_table :replies, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
        t.column :topic_id,         :integer
        t.column :user_id,           :integer
        
        t.column :text,               :text 
        
        t.column :created_at,       :datetime
        t.column :updated_at,       :datetime 
    end
  end

  def self.down
    drop_table :replies
  end
end
