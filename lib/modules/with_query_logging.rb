module Modules
  module WithQueryLogging
    def self.included(base)
      base.class_eval {
        before_filter :log_query, :only => :index
      }
    end

    private
    def log_query
      @site.search_queries.create(:query => params[:search])
    end
  end
end