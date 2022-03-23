#class CreateUsers < ActiveRecord::Migration
class User < ActiveRecord::Migration
  def self.up
    create_table "forms", :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :data,                      :string
      t.column :title,                     :string
    end
  end

  def self.down
    drop_table "forms"
  end
end
