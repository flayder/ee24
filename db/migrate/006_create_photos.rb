class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :photo_id,         :integer
      t.column :photo_type,       :string
      
      t.column :created_at,       :datetime
      t.column :updated_at,       :datetime
      
      t.column :image,            :string
      t.column :title,            :string
      t.column :main,             :boolean, :nil => false, :default => false
    end
  end

  def self.down
    drop_table :photos
  end
end
