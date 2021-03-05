class AddBlock < ActiveRecord::Migration
  def self.up
    create_table :blocks, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8'  do |t|
      t.string      "title"
      t.text        "block"
      t.string      "link"
      t.boolean     "main"
      t.boolean     "active"
      t.timestamps
    end
  end

  def self.down
    drop_table :blocks
  end
end
