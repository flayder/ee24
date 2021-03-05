class CreateBlackListWords < ActiveRecord::Migration
  def change
    create_table :black_list_words do |t|
      t.string :lemma
      t.integer :site_id

      t.timestamps
    end

    add_index :black_list_words, :site_id
    add_index :black_list_words, :lemma, unique: true
  end
end
