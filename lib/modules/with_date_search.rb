module Modules
  module WithDateSearch
    private
    def extract_date_range params
      if params[:year] && !params[:month] && !params[:day]
        start_date = Date.new(params[:year].to_i).beginning_of_year
        end_date = start_date.end_of_year
      elsif params[:year] && params[:month] && !params[:day]
        start_date = Date.new(params[:year].to_i, params[:month].to_i).beginning_of_month
        end_date = start_date.end_of_month
      elsif params[:year] && params[:month] && params[:day]
        start_date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i).beginning_of_day
        end_date = start_date.end_of_day
      else
        raise_error ArgumentError
      end

      start_date..end_date
    end
  end
end