class Api::V1::DocGlobalRubrics::DocsController < Api::V1::BaseController
  def count
    doc_global_rubric = current_site.doc_global_rubrics.find params[:doc_global_rubric_id]
    respond_with count: doc_global_rubric.docs(current_site).approved.date_between(time_range, !!(params[:include_boundary_dates])).size
  end
end
