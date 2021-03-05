ThinkingSphinx::Index.define :vacancy, with: :active_record do
  indexes title
  indexes company_name
  indexes contacts

  set_property field_weights: { title: 4, text: 2, company_name: 2, contacts: 1 }
  has approved, created_at
end
