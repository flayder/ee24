class Search::CompaniesController < ApplicationController
  include Modules::WithSearch
  
  def index
    search classes: [Catalog]
    respond_to do |format|
      format.html
      format.json {render_next_page}
    end
  end
end