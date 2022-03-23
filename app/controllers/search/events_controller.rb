#encoding: utf-8

class Search::EventsController < ApplicationController
  include Modules::WithSearch

  def index
    #search classes: [Event]
    page = params[:page].to_i > 0 ? params[:page] : 1
    query = "%#{params[:search].to_s}%"
    if params[:search] and params[:search].length > 0
      @results = @site.events.by_language.where("title LIKE ?", query).order(:created_at).reverse_order.paginate(:page => page, :per_page => 50)
      @meta_title = ["Поиск по запросу " + '"'+ "#{params[:search]}" + '". ' + Settings.portal_title + " " + Settings.portal_domain]
    else
      @meta_title = ["Поиск. #{Settings.portal_title} #{Settings.portal_domain}"]
    end
    #render json: @results
    respond_to do |format|
      format.html
      #format.json {render_next_page}
    end
  end
end
