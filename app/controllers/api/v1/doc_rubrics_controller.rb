class Api::V1::DocRubricsController < Api::V1::BaseController
  def index
    global_rubric = current_site.doc_global_rubrics.find params[:doc_global_rubric_id]
    respond_with doc_rubrics: global_rubric.doc_rubrics
  end

  def doc_ids
    doc_rubric = current_site.doc_rubrics.find params[:doc_rubric_id]
    respond_with doc_ids: load_doc_ids(doc_rubric)
  end

  private
  def load_doc_ids doc_rubric
    Doc.where(doc_rubric_id: doc_rubric.id).approved.date_between(time_range, !!(params[:include_boundary_dates])).order('created_at DESC').pluck(:id)
  end
end
