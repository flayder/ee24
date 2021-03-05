ThinkingSphinx::Index.define :event, with: :active_record do
  indexes title
  indexes text
  indexes annotation
  where sanitize_sql(["approved", true])

  set_property field_weights: { title: 4, text: 2, annotation: 1 }
  has site_id, created_at, approved
end
