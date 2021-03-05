class Search::VacanciesController < ApplicationController
  include Modules::WithSearch

  def index
    search classes: [Vacancy]
    params[:type] = 'vacancy'
    respond_to do |format|
      format.html
      format.json {render_next_page}
    end
  end
end
