class AddTermsGdprToUsers < ActiveRecord::Migration
  def change
    add_column :users, :terms, :boolean, default: false
    add_column :users, :gdpr, :boolean, default: false
  end
end
