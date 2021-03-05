class SemanticApi::V1::DocsController < SemanticApi::V1::BaseController
  class Doc < ::Doc
    def as_json(options = nil)
      super(options).merge(
        'url' => url,
        'image_url' => main_photo.try(:image).try(:url, :small),
        'annotation' => annotation
      )
    end
  end

  before_filter :check_token

  def index
    tag = current_site.tags.find_by_name!(params[:tag])
    docs = Doc.site(current_site).includes(taggings: :tag).where(tags: { name: tag.name })

    respond_with docs.as_json
  end

  def page_views
    docs = current_site.docs.where(id: params[:ids].split(','))
    respond_with docs.select('id, page_views').as_json
  end

  private
  def check_token
    authenticate_or_request_with_http_token do |token, options|
      SemanticApiTokens["#{current_site.domain}"]["token"] == token
    end
  end
end
