class Design::StylesheetsController < ApplicationController
  def show
    stylesheet = @site.design_stylesheets.find_by_name(params[:id])

    respond_to do |format|
      format.css { render text: stylesheet.body, content_type: "text/css" }
    end
  end
end
