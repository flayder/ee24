#encoding: utf-8
class Admin::BlackListWordsController < Admin::BaseController
  authorize_resource :black_list_word

  def index
    @search = BlackListWord.metasearch params[:search]
    @black_list_words = @search.page params[:page]
  end

  def new
    @black_list_words = BlackListWords.new
  end

  def create
    @black_list_words = BlackListWords.new(params[:black_list_words])

    if @black_list_words.create_bunch
      redirect_to admin_black_list_words_path, :notice => 'Запись успешно создана'
    else
      render :action => :new
    end
  end

  def destroy
    BlackListWord.find(params[:id]).destroy
    redirect_to :action => :index
  end
end
