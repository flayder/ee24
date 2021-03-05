#encoding: utf-8
class Admin::EventRubricsController < Admin::BaseController
  authorize_resource :event_rubric

  def index
    @search = EventRubric.site(@site).metasearch params[:search]
    @event_rubrics = @search.page params[:page]
  end

  def new
    @event_rubric = EventRubric.new
    @event_rubric.site = @site
  end

  def create
    @event_rubric = @site.event_rubrics.new params[:event_rubric], as: :admin

    if @event_rubric.save
      redirect_to admin_event_rubrics_path, notice: 'Рубрика успешно создана'
    else
      render action: :new
    end
  end

  def edit
    @event_rubric = @site.event_rubrics.find params[:id]
  end

  def update
    @event_rubric = @site.event_rubrics.find params[:id]

    if @event_rubric.update_attributes params[:event_rubric], as: :admin
     redirect_to action: :index, notice: 'Словарная рубрика успешно обновлена'
    else
     render action: :edit
    end
  end

  def destroy
    @site.event_rubrics.find(params[:id]).destroy
    redirect_to action: :index
  end
end
