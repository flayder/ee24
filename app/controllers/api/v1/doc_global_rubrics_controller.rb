class Api::V1::DocGlobalRubricsController < Api::V1::BaseController
  def index
    doc_global_rubrics = current_site.doc_global_rubrics.includes(:doc_rubrics).limit(nil || params[:limit])

    if stale? etag: doc_global_rubrics.as_json, last_modified: doc_global_rubrics.maximum(:updated_at)
      respond_with doc_global_rubrics: doc_global_rubrics.as_json
    end
  end
end
