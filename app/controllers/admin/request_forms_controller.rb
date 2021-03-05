class Admin::RequestFormsController < Admin::BaseController

  def index
    @search = RequestForm.metasearch params[:search]
    @request_forms = @search.page params[:page]
  end

  def destroy
    RequestForm.find(params[:id]).destroy
    redirect_to action: :index
  end

end
