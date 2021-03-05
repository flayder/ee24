# encoding : utf-8
class Admin::DictionariesController < Admin::BaseController
  authorize_resource :dictionary

  def index
    @dictionaries = @site.dictionaries.page params[:page]
  end

  def show
    @dictionary = @site.dictionaries.find params[:id]
  end

  def new
    @dictionary = @site.dictionaries.build
  end

  def create
    @dictionary = @site.dictionaries.build params[:dictionary]
    @dictionary.site = @site

    if @dictionary.save
      redirect_to [:admin, @dictionary], :notice => 'Словарь создан.'
    else
      render :new, :error => 'Возникли ошибки, словарь не создан.'
    end
  end

  def edit
    @dictionary = @site.dictionaries.find params[:id]
  end

  def update
    @dictionary = @site.dictionaries.find params[:id]

    if @dictionary.update_attributes params[:dictionary]
      redirect_to [:admin, @dictionary], :notice => 'Словарь обновлен.'
    else
      render :edit, :error => 'Возникли ошибки, словарь не может быть обновлен.'
    end 
  end

  def destroy
    @dictionary = @site.dictionaries.find params[:id]
    if @dictionary.destroy
      redirect_to :action => :index, :notice => 'Словарь удален.'
    else
      redirect_to :action => :index, :error => 'Словарь не может быть удален.'
    end
  end
end