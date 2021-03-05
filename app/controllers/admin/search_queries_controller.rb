class Admin::SearchQueriesController < Admin::BaseController
  authorize_resource :search_query

  def index
    @search = SearchQuery.site(@site).metasearch(params[:search])
    @search_queries = @search.page(params[:page])
  end
end
