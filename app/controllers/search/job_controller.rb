#encoding: utf-8

class Search::JobController < ApplicationController
  include Modules::WithSearch

  def index
    page = params[:page].to_i > 0 ? params[:page] : 1
    query = "%#{params[:search].to_s}%"
    if params[:search] and params[:search].length > 0
      @results = Vacancy.approved.where("title LIKE ?", query).order(:created_at).reverse_order.paginate(:page => page, :per_page => 50)
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
