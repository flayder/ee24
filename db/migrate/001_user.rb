#class CreateUsers < ActiveRecord::Migration
class User < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :login,                     :string
      t.column :email,                     :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime

      t.column :real_name,                 :string
      t.column :city,                      :string
      t.column :gender,                    :string
      t.column :interests,                 :text
      t.column :icq,                       :string
      t.column :skype,                     :string
      t.column :about,                     :text
      t.column :avatar,                    :string

      t.column :ban,                       :boolean, :default => "0", :null => false
      t.column :user_type,                 :string, :default => "user", :null => false
    end
  end

  def self.down
    drop_table "users"
  end
end
