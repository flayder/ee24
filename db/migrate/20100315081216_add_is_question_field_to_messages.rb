class AddIsQuestionFieldToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :is_question, :boolean, :default => false
  end

  def self.down
    remove_column :messages, :is_question
  end
end
