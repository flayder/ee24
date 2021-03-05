class CategoriesController < ApplicationController

  def index
    @categories = Category.all
    @questions = Question.by_language.order('created_at DESC').paginate(page: params[:page], per_page: 20)
    @users = User.top5_by_questions
  end

  def show
    @categories = Category.all
    @category = Category.find_by_id(params[:id])
    return render_404 unless @category
    @questions = @category.questions.by_language.order("created_at DESC").paginate(page: params[:page], per_page: 20)
  end

end
