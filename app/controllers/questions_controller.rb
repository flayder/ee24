# encoding : utf-8
class QuestionsController < ApplicationController

  before_filter :find_question, only: [:show, :edit, :update, :destroy]
  before_filter :get_categories_list
  before_filter :login_required, only: [:my, :new, :create, :edit, :update, :destroy]
  before_filter :find_category, only: [:index, :show, :edit, :update, :destroy, :new]
  authorize_resource

  def index
    @questions = @category.questions.by_language.paginate(:page => params[:page], :per_page => 10)
  end

  def not_approved
    @questions = Question.not_approved.order('id DESC').uniq
    @questions = params[:editor] ? @questions.editor_generated : @questions.user_generated
    @questions = @questions.paginate(:page => params[:page], :per_page => 10)

    @meta_title = 'Неподтверждённые посты'
    @broads = ['Неподтверждённые посты']
    render :list
  end

  def my
    @questions = current_user.questions.order('id DESC').paginate(:page => params[:page], :per_page => 10)
    @meta_title = t('.my_questions_header')
    @broads = [t('.my_questions_header')]
    respond_to do |format|
      format.html { render :my }
      format.json {render_next_page}
    end
  end

  def popular
    if params[:category_id]
      @questions = Question.where(category_id: params[:category_id]).popular.by_language.paginate(:page => params[:page], :per_page => 10)
    else
      @questions = Question.popular.by_language.paginate(:page => params[:page], :per_page => 10)
    end
    @meta_title = t('.popular_questions_header')
    @broads = [t('.popular_questions_header')]
    respond_to do |format|
      format.html { render :popular }
      format.json {render_next_page}
    end
  end

  def show
    @relevant_questions = @question.category.questions.by_language.where("id != ?", @question.id).last(4)
    @latest_questions = Question.by_language.where("id != ?", params[:id]).last(5)
    @meta_title = "#{@question.title} | #{@category.name}"
  end

  def new
    @question = Question.new
    @question.category = @category
  end

  def edit
  end

  def create
    @question = Question.new(params[:question])
    @question.language = I18n.locale.to_s
    @question.user = current_user
    if @question.save
      redirect_to categories_path
    else
      render "new"
    end
  end

  def update
    if @question.update_attributes(params[:question].merge(language: I18n.locale.to_s))
      redirect_to category_path(@category)
    else
      render "edit"
    end
  end

  def destroy
    @question.destroy
    redirect_to category_path(@category)
  end

  private

  def find_question
    @question = Question.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def get_categories_list
    @categories = Category.all
    @users = User.top5_by_questions
  end

  def find_category
    @category = Category.find(params[:category_id]) if params[:category_id].present?
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
