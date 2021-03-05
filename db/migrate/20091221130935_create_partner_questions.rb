class CreatePartnerQuestions < ActiveRecord::Migration
  def self.up
    create_table :partner_questions do |t|
      t.integer :partner_id
      t.integer :user_id
      t.text :question
      t.text :answer
      t.timestamps
    end
  end

  def self.down
    drop_table :partner_questions
  end
end
