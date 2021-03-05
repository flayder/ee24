class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :comment_id,       :integer
      t.column :comment_type,     :string
      
      t.column :number,           :integer
      
      t.column :created_at,       :datetime
      t.column :updated_at,       :datetime
      
      t.column :title,            :string
      t.column :text,             :text
    end
  end

  def self.down
    drop_table :comments
  end
end
