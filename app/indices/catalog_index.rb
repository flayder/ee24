ThinkingSphinx::Index.define :catalog, with: :active_record do
  indexes catalog_descriptions.title, as: :title
  indexes catalog_descriptions.text, as: :text
  indexes catalog_descriptions.annotation, as: :annotation

  where sanitize_sql(["approved", true])

  set_property field_weights: { title: 4, text: 2, annotation: 1 }
  has site_id, approved, created_at, lat, lng
end
