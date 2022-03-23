#encoding: utf-8

class Search::DocsController < ApplicationController
  #include Modules::WithSearch

  def index
    # Protection from chinese seo requests

    if params[:search].split(//).select {|a| !a.match(/[\wа-яА-Яa-žA-Ž\.\,\:\s\-\—\«\»\+\°\&\%\?\#\@\*\(\)\=]+/) }.any?
      raise ActionController::RoutingError.new('Not Found')
    end
    page = params[:page].to_i > 0 ? params[:page] : 1
    query = "%#{params[:search].to_s}%"
    if params[:search] and params[:search].length > 0
      @results = Doc.where("title LIKE ?", query).order(:created_at).reverse_order.paginate(:page => page, :per_page => 50)
      @meta_title = ["Поиск по запросу " + '"'+ "#{params[:search]}" + '". ' + Settings.portal_title + " " + Settings.portal_domain]
    else
      @meta_title = ["Поиск. #{Settings.portal_title} #{Settings.portal_domain}"]
    end
    #render json: @docs
    #search classes: [Doc]
    #render template: "search/docs/index"
    # respond_to do |format|
    #   format.html
    #   #format.json {render_next_page}
    # end
  end

end
