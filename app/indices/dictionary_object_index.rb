ThinkingSphinx::Index.define :dictionary_object, with: :active_record do
  indexes title
  indexes text
  where sanitize_sql(["approved", true])

  set_property field_weights: { title: 4, text: 2 }
  has created_at, approved, site_id
end
