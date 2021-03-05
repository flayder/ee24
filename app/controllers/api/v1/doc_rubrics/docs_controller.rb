class Api::V1::DocRubrics::DocsController < Api::V1::BaseController
  def count
    doc_rubric = current_site.doc_rubrics.find params[:doc_rubric_id]
    respond_with count: doc_rubric.docs.approved.date_between(time_range, !!(params[:include_boundary_dates])).size
  end
end
