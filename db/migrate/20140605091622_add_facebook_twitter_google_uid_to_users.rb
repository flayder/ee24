class AddFacebookTwitterGoogleUidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_uid, :string
    add_column :users, :twitter_uid, :string
    add_column :users, :google_oauth2_uid, :string
  end
end
