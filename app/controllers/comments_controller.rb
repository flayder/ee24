#encoding: utf-8
class CommentsController < ApplicationController
  before_filter :user_confirmed, only: [:new, :edit, :create, :update, :delete]

  def index
    begin
      @doc = params[:doc_class].constantize.find(params[:doc_id])
    rescue
      return render json: {flash: 'Document not found'}, status: 404
    end
    @comments = @doc.comments.roots
    @comments = if params[:order] == 'new'
      @comments.reorder('created_at DESC')
    elsif params[:order] == 'rating'
      @comments.sort_by {|c| c.rating }.reverse
    else
      @comments
    end
    @collapsed = params[:doc_class] == 'Question'? false : true
    respond_to do |format|
      format.json { render json: {comments: render_to_string('comments/_comments_full', locals: {comments: @comments, order: params[:order], collapsed: @collapsed}, layout: false, formats: [:html])} }
    end
  end

  def create
    comment = Comment.new(params[:comment])
    comment.user = current_user
    authorize! :create, comment
    if comment.save
      Resque.enqueue(Mailer, 'CommentMailer', :reply, comment.id) if comment.parent
      comment.commentable.comment_subscribers.map(&:user).each do |subscriber|
        Resque.enqueue(Mailer, 'CommentMailer', :subscribe, comment.id, current_user.id) if subscriber != current_user
      end
      flash[:notice] = 'Комментарий добавлен'
      respond_to do |format|
        format.json { render json: {flash: flash.discard, comment: render_to_string('comments/_comment', locals: {comment: comment}, layout: false, formats: [:html])}}
        format.html { redirect_to :back }
      end
    else
      flash[:alert] = 'При добавлении комментария возникли ошибки'
      respond_to do |format|
        format.json { render json: {flash: flash.discard, errors: comment.errors}, status: :unprocessable_entity }
        format.html {}
      end
    end
  end

  def edit
    comment = Comment.find(params[:id])
    authorize! :update, comment
    respond_to do |format|
      format.json { render json: {flash: flash.discard, comment: render_to_string('comments/edit', locals: {comment: comment}, layout: false, formats: [:html])}}
      format.html {}
    end
  end

  def update
    comment = Comment.find(params[:id])
    authorize! :update, comment
    if comment.update_attributes(params[:comment])
      flash[:notice] = 'Комментарий отредактирован'
      respond_to do |format|
        format.json { render json: {flash: flash.discard, comment: comment.text}}
        format.html { redirect_to request.referer.present? ? :back : root_path }
      end
    else
      flash[:alert] = 'Не удалось отредактировать комментарий'
      respond_to do |format|
        format.json { render json: {flash: flash.discard, errors: comment.errors}, status: :unprocessable_entity }
        format.html {}
      end
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    authorize! :destroy, comment
    if comment.destroy
      flash[:notice] = 'Комментарий удален'
      respond_to do |format|
        format.json { render json: {flash: flash.discard}}
        format.html { redirect_to request.referer.present? ? :back : root_path }
      end
    else
      flash[:alert] = 'Не удалось удалить комментарий'
      respond_to do |format|
        format.json { render json: {flash: flash.discard, errors: comment.errors}, status: :unprocessable_entity }
        format.html {}
      end
    end
  end

  def by_user_delete
    comment = Comment.find(params[:comment_id])
    authorize! :destroy, comment
    if comment.user.comments.destroy_all
      flash[:notice] = 'Все комментарии пользователя удалены'
    else
      flash[:alert] = 'Не удалось удалить комментарии пользователя'
    end
    redirect_to request.referer.present? ? :back : root_path
  end

  private

  def user_confirmed
    if current_user.present? && !current_user.confirm?
      flash[:notice] = 'Пожалуйста подтвердите ваш аккаунт, перейдя по ссылке в письме, для получения возможности комментирования'
      render json: {flash: flash.discard}, status: :unprocessable_entity
    end
  end

end
