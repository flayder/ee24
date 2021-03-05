class MigratedDocFinder
  class << self
    def find_doc rubric, id
      doc = rubric.docs.double_migrated.find_by_news_doc_doc_id(id)
      return doc if doc_found?(doc, id)

      doc = rubric.docs.migrated_once.find_by_news_doc_id(id)
      return doc if doc_found?(doc, id)

      nil
    end

    private
    def id_param id
      id.split('-', 2)[1]
    end

    def doc_found? doc, id
      doc && doc.param == id_param(id)
    end
  end
end
