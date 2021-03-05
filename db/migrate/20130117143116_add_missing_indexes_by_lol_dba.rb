class AddMissingIndexesByLolDba < ActiveRecord::Migration
  def change
    add_index :profession_objects, [:vacancy_id, :profession_id]
    add_index :profession_objects, [:resume_id, :profession_id]
    add_index :profession_objects, [:profession_id, :resume_id]
    add_index :profession_objects, [:profession_id, :vacancy_id]
    add_index :seos, :site_id
    add_index :seos, [:seo_id, :seo_type]
    add_index :taggings, [:tagger_id, :tagger_type]
    add_index :event_users, :user_id
    add_index :event_users, :event_id
    add_index :event_users, [:user_id, :event_id]
    add_index :social_comments_counters, [:social_comments_countable_id, :social_comments_countable_type], :name => 'social_comments_counters_id_type_index'
    add_index :board_photos, [:photoable_id, :photoable_type]
    add_index :doc_ratings, [:ratable_id, :ratable_type]
    add_index :metrika_api_account_search_queries, :url_id
    add_index :photos, [:photo_id, :photo_type]
    add_index :dictionary_objects, [:id, :type]
    add_index :web_analytics_blocks, :site_id
    add_index :topic_watches, :topic_id
    add_index :topic_watches, :forum_id
    add_index :topic_watches, :user_id
    add_index :catalog2s, :site_id
    add_index :catalog_rubrics, [:rubric_id, :catalog_id]
    add_index :catalog_rubrics, [:catalog_id, :rubric_id]
    add_index :catalog_galleries, [:gallery_id, :catalog_id]
    add_index :comments, [:comment_id, :comment_type]
    add_index :menus, :parent_id
    add_index :galleries, :photo_global_rubric_id
    add_index :ips, [:ip_object_id, :ip_object_type]
    add_index :catalog_global_rubrics, :parent_id
    add_index :site_rubrics, [:rubric_id, :rubric_type]
    add_index :counts, :site_id
    add_index :counts, [:count_id, :count_type]
    add_index :accesses, :user_id
    add_index :accesses, :menu_id
    add_index :boards, :site_id
  end
end
