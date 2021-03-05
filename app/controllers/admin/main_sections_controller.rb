#encoding: utf-8
class Admin::MainSectionsController < Admin::BaseController
  authorize_resource :main_section

  def index
    @main_sections = MainSection.order(created_at: :desc)
  end

  def edit
    @main_section = MainSection.find(params[:id])
  end

  def update
    @main_section = MainSection.find(params[:id])

    if @main_section.update_attributes params[:main_section]
      redirect_to action: :index
    else
     render action: :edit
    end
  end
end
