class CreateRubricDocs < ActiveRecord::Migration
  def self.up
    create_table :rubric_docs, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :title,                      :string
      t.timestamps
    end
  end

  def self.down
    drop_table :rubric_docs
  end
end
