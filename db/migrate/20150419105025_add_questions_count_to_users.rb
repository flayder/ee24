class AddQuestionsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :questions_count, :integer, default: 0

    User.reset_column_information
    User.find_each do |p|
      User.reset_counters p.id, :questions
    end
  end
end
