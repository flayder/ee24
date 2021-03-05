class Search::EventsController < ApplicationController
  include Modules::WithSearch

  def index
    search classes: [Event]
    respond_to do |format|
      format.html
      format.json {render_next_page}
    end
  end
end
