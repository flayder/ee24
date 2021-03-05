# encoding : utf-8
class DocRatingsController < ApplicationController
  cache_sweeper :doc_rating_sweeper
  before_filter :user_confirmed, only: :vote

  def vote
    result = {:success => false}
    if params[:doc_class].present? and params[:doc_id].present?
      if logged_in?
        doc = doc_klass.find(params[:doc_id])
        rating = doc.ratings.new(:user_id => current_user.id, :value => params[:value].to_i)
        result[:success] = rating.save
        if result[:success]
          result[:rating] = doc.rating
          ratings_cnt = doc.ratings.count
          result[:cnt_text] = '( '+ratings_cnt.to_s+' '+Russian.p(ratings_cnt, 'голос', 'голоса', 'голосов')+' )'
        else
          result[:message] = rating.errors.map {|r| r[1]}.join(', ')
        end
      else
        result[:message] = 'Голосование доступно только для зарегистрированных пользователей'
      end
    else
      result[:message] = 'Не удалось'
    end
    render :json => result
  end

  def not_allowed
    if logged_in?
      if current_user.confirm?
        redirect_to :back
      else
        flash[:message] = 'Для голосования вам необходимо подтвердить аккаунт'
        redirect_to user_not_confirm_path(current_user.subdomain)
      end
    else
      flash[:login_error] = 'Для голосования необходимо авторизироваться или <a href="/account/signup">зарегистрироваться</a>'.html_safe
      redirect_to '/users/sign_in'
    end
  end

  private
  def doc_klass
    if params[:doc_class].classify.in?(DocRating::TYPES)
      params[:doc_class].classify.constantize
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
