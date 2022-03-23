class Admin::FormsController < Admin::BaseController

  def index
    @search = Form.metasearch params[:search]
    @request_forms = @search.page params[:page]
  end

  def destroy
    Form.find(params[:id]).destroy
    redirect_to action: :index
  end

end
