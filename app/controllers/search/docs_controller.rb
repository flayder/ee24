#encoding: utf-8

class Search::DocsController < ApplicationController
  include Modules::WithSearch

  def index
    # Protection from chinese seo requests
    if params[:search].split(//).select {|a| !a.match(/[\wа-яА-Яa-žA-Ž\.\,\:\s\-\—\«\»\+\°\&\%\?\#\@\*\(\)\=]+/) }.any?
      raise ActionController::RoutingError.new('Not Found')
    end

    search classes: [Doc]
    respond_to do |format|
      format.html
      format.json {render_next_page}
    end
  end

end
