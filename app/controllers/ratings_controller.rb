#encoding: utf-8
class RatingsController < ApplicationController

  def create
    rating = Rating.new(params)
    rating.user = current_user
    comment = Comment.find params[:rateable_id]
    authorize! :create, rating
    if rating.save
      flash[:notice] = 'Ваш голос учтён'
      respond_to do |format|
        format.json { render json: {flash: flash.discard, rate: render_to_string('comments/_rate', locals: {comment: comment}, layout: false, formats: [:html])}}
        format.html { redirect_to :back }
      end
    else
      flash[:alert] = 'Возникли ошибки'
      respond_to do |format|
        format.json { render json: {flash: flash.discard, errors: rating.errors}, status: :unprocessable_entity }
        format.html {}
      end
    end
  end

end
