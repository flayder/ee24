module WithSimilarDocs
  def similar_docs
    tag = self.tags.first
    tag.present? ? self.class.approved.where("#{self.class.table_name}.id != ?", self.id).site(self.site).tagged_with(tag.name, any: true).order('created_at DESC') : []
    #self.rubric.docs.where("#{self.class.table_name}.id != ?", self.id).approved.site(self.site).order('created_at DESC').limit(3)
  end
end