ThinkingSphinx::Index.define :gallery, with: :active_record do
  indexes title
  indexes annotation
  indexes annotation_card

  where sanitize_sql(["approved", true])
  set_property field_weights: { title: 5, annotation: 4, annotation_card: 2 }
  has created_at, approved, site_id
end
