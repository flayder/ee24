class Api::V1::DocsController < Api::V1::BaseController
  class Doc < ::Doc
    DEFAULT_LIMIT = 20
    MAX_LIMIT = 100

    def as_json options = nil
      super(options).merge(
        'created_at' => created_at.to_i,
        'updated_at' => updated_at.to_i,
        'author' => user.try(:fio_or_login),
        'rating' => rating,
        'created_at_string' => Russian::strftime(created_at, '%d %B %Y, %H:%M')
      ).merge(thumbnail_params)
    end

    private
    def thumbnail_params
      return {} unless main_photo.try(:image)

      {
        thumbnail_name: main_photo[:image],
        thumbnail_path: main_photo.image.url.gsub(main_photo[:image], '')
      }
    end
  end

  def index
    doc_rubric = current_site.doc_rubrics.find params[:doc_rubric_id]
    docs = load_docs doc_rubric
    respond_with docs: docs.map { |doc| doc_json(doc, params[:text]) }
  end

  def show
    doc = Doc.site(current_site).approved.find(params[:id])
    respond_with doc: doc_json(doc, params[:text])
  end

  def show_html
    @doc = Doc.site(current_site).approved.find params[:doc_id]
    render template: 'api/v1/docs/show_html', locals: { doc: @doc }, layout: 'mobile'
  end

  def count
    respond_with count: current_site.docs.approved.date_between(time_range, !!(params[:include_boundary_dates])).size
  end

  private
  def load_docs doc_rubric
    docs = Doc.where(doc_rubric_id: doc_rubric.id).approved.date_between(time_range, !!(params[:include_boundary_dates]))
    docs = docs.where(id: params[:ids].split(',')) if params[:ids]
    docs = docs.order('created_at DESC').paginate(page: params[:page], per_page: docs_limit(params[:limit]))
  end

  def doc_json doc, render_text = false
    json = doc.as_json
    json['text'] = render_to_string(
      'api/v1/docs/show_html.html',
      locals: { doc: doc },
      layout: 'mobile'
    ) if render_text
    json
  end

  def docs_limit limit
    limit ? [Doc::MAX_LIMIT, limit.to_i].min : Doc::DEFAULT_LIMIT
  end
end
