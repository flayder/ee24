#encoding: utf-8
class Admin::CommentsController < Admin::BaseController

  def index
    @q = Comment.metasearch(params[:q])
    @comments = @q.order('updated_at DESC').page(params[:page])
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])

    if @comment.update_attributes(params[:comment])
      flash[:notice] = 'Комментарий отредактирован'
      redirect_to action: :index
    else
      flash[:alert] = 'Не удалось отредактировать комментарий'
      redirect_to action: :index
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      flash[:notice] = 'Комментарий удален'
      redirect_to action: :index
    else
      flash[:alert] = 'Не удалось удалить комментарий'
      redirect_to action: :index
    end
  end

  def by_user_delete
    comment = Comment.find(params[:comment_id])
    if comment.user.comments.destroy_all
      flash[:notice] = 'Все комментарии пользователя удалены'
    else
      flash[:alert] = 'Не удалось удалить комментарии пользователя'
    end
    redirect_to request.referer.present? ? :back : root_path
  end

end
