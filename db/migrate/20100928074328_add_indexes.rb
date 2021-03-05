class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :photos, :photo_id
    add_index :photo_global_rubrics, :parent_id

    add_index :galleries, :root_id
    add_index :galleries, :city_id
    add_index :galleries, :user_id

    add_index :messages, :user_id
    add_index :messages, :sender_id

    add_index :forums, :forums_group_id
    add_index :topics, :forum_id
    add_index :topics, :user_id
    add_index :replies, :topic_id
    add_index :replies, :user_id
    add_index :replies, :forum_id

    add_index :comments, :comment_id
    add_index :comments, :user_id
    add_index :comments, :parent_id

    add_index :rubric_docs, :global_rubric_id
    add_index :news_docs, :news_rubric_id
    add_index :docs, :rubric_doc_id

    add_index :interesting_infs, :doc_id

    add_index :events, :event_rubric_id
  end

  def self.down
    remove_index :photos, :photo_id
    remove_index :photo_global_rubrics, :parent_id

    remove_index :galleries, :root_id
    remove_index :galleries, :city_id
    remove_index :galleries, :user_id

    remove_index :messages, :user_id
    remove_index :messages, :sender_id

    remove_index :forums, :forums_group_id
    remove_index :topics, :forum_id
    remove_index :topics, :user_id
    remove_index :replies, :topic_id
    remove_index :replies, :user_id
    remove_index :replies, :forum_id

    remove_index :comments, :comment_id
    remove_index :comments, :user_id
    remove_index :comments, :parent_id

    remove_index :rubric_docs, :global_rubric_id
    remove_index :news_docs, :news_rubric_id
    remove_index :docs, :rubric_doc_id

    remove_index :interesting_infs, :doc_id

    remove_index :events, :event_rubric_id
  end
end
