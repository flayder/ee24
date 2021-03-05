#encoding: utf-8
class CommentSubscribersController < ApplicationController

  def create
    subscriber = CommentSubscriber.create(subscriberable_id: params[:id], subscriberable_type: params[:class], user: current_user)
    respond_to do |format|
      format.json { render json: { ok: true }}
      format.html { redirect_to :back, notice: "Теперь вы будете получить уведомления о новых комментариях"  }
    end
  end

  def destroy
    subscriber = CommentSubscriber.where(subscriberable_id: params[:id], subscriberable_type: params[:class], user_id: current_user).first
    subscriber.try(:destroy)
    respond_to do |format|
      format.json { render json: { ok: true }}
      format.html { redirect_to :back, notice: "Теперь вы не будете получать уведомления о новых комментариях" }
    end
  end

end
