# encoding : utf-8
class AccountController < ApplicationController
  include Modules::WithCommonLayout

  before_filter :find_user, except: [:confirm, :not_confirm, :update_password,
  :update, :profile, :signup, :create, :restore, :restore_pwd,
  :restore_password, :add_friend_approve, :friend_approved,
  :friend_not_approved]
  before_filter :init_friendship, only: [:add_friend_approve, :friend_approved, :friend_not_approved, :del_friend]
  before_filter :check_signed_in_for_confirm, only: :not_confirm
  before_filter :login_required, only: [:edit, :update, :change_password, :change_avatar, :update_password, :update_avatar]

  def docs
    if !@user.hide_profile? || logged_in?
      @docs = @user.docs.approved.includes(rubric: :global_rubric).order("created_at desc").paginate(page: params[:page], per_page: 14)
      @meta_title = ["Статьи #{@user.login} / #{@site.short_title} #{@site.domain}. #{@site.portal_title}."]
      respond_to do |format|
        format.html
        format.json {render_next_page(@docs)}
      end
    else
      flash_login_error
      redirect_to login_url(:subdomain => false)
    end
  end

  def events
    if !@user.hide_profile? || logged_in?
      @events = @user.events.approved.order("created_at desc").paginate(page: params[:page], per_page: 14)
      @meta_title = ["События #{@user.login} / #{@site.short_title} #{@site.domain}. #{@site.portal_title}."]
      respond_to do |format|
        format.html
        format.json {render_next_page(@events)}
      end
    else
      flash_login_error
      redirect_to login_url(:subdomain => false)
    end
  end

  def photos
    if !@user.hide_profile? || logged_in?
      @galleries = @user.galleries.approved.order("created_at desc").paginate(page: params[:page], per_page: 5)
      @meta_title = ["Фото #{@user.login} / #{@site.short_title} #{@site.domain}. #{@site.portal_title}."]

      respond_to do |format|
        format.html
        format.json {
          render json: {
              col1: render_to_string('photo/_galleries_list_extended', locals: {galleries_list_extended: @galleries}, layout: false, formats: [:html]),
              page: @galleries.next_page
          }
        }
      end
    else
      flash_login_error
      redirect_to login_url(:subdomain => false)
    end
  end

  def comments
    if !@user.hide_profile? || logged_in?
      @comments = @user.comments.order("created_at desc").paginate(page: params[:page], per_page: 20)
      @meta_title = ["Комментарии #{@user.login} / #{@site.short_title} #{@site.domain}. #{@site.portal_title}."]
    else
      flash_login_error
      redirect_to login_url(:subdomain => false)
    end
  end

  def friends
    authorize!(:friends, @user)
    @friends = @user.friends.paginate(per_page: 25, page: params[:page])
    @meta_title = ['Друзья']
    @broads = ['Друзья']
  end

  def companies
    if !@user.hide_profile? || logged_in?
      @companies = @user.catalogs.order("created_at desc").paginate(per_page: 10, page: params[:page])
      @meta_title = ["Компании #{@user.login} / #{@site.short_title} #{@site.domain}. #{@site.portal_title}."]
    else
      flash_login_error
      redirect_to login_url(:subdomain => false)
    end
  end

  def profile
    @user = User.find_by_subdomain params[:id]
    return render_404 unless @user
    @last_docs = @user.docs.approved.includes(rubric: :global_rubric).order("created_at desc").limit(3)
    @last_events = @user.events.approved.order("created_at desc").limit(3)
    @last_galleries = @user.galleries.approved.order("created_at desc").limit(3)
    @meta_title = [@user.login + " / #{@site.short_title} #{@site.domain}. #{@site.portal_title}."]
    @broads = ["Профиль #{@user.login}"]
  end

  def edit
    @broads = ['Редактирование профиля']
    @meta_title = ['Редактирование профиля']
    @user = current_user
  end

  def not_confirm
    if current_user.confirm?
      redirect_to root_path, notice: 'Ваш аккаунт уже подтвержден.'
    else
      @meta_title = ['Подтверждение регистрации']
      @broads = ['Подтверждение регистрации']
    end
  end

  def confirm
    user = @site.users.not_confirmed.find_by_subdomain_and_confirmation_token(params[:user_id], params[:confirmation_token])
    unless user
      flash[:error] = 'Либо ваш аккаунт уже подтвержден, либо не верный токен подтверждения.'
      return redirect_to(root_path)
    end

    user.confirm = true
    user.confirmation_token = nil
    user.confirmed_at = Time.now

    if user.save
      warden.set_user user
      flash[:message] = 'Ваша регистрация успешно подтверждена.'
    else
      flash[:message] = 'Ваша регистрация не была подтверждена.'
    end

    redirect_to user_url(user.subdomain)
  end

  def update_avatar
    set_avatar

    if @user.save
      flash[:notice] = 'Аватар обновлен успешно.'
      redirect_to user_url(@user.subdomain)
    else
      flash[:notice] = 'При обновлении аватара возникла ошибка.'
      redirect_to user_change_avatar_url(@user.subdomain)
    end
  end

  def update_password
    @user = current_user

    if User.authenticate(current_user.email, params[:old_password]) && @user.update_attributes(params[:user])
      redirect_to user_url(current_user.subdomain), notice: 'Пароль обновлен'
    else
      @meta_title = ['Смена пароля']
      @broads = ['Смена пароля']
      render :action => :change_password
    end
  end

  def update
    @user = current_user
    if @user.update_attributes params[:user]
      flash[:notice] = 'Профайл обновлен'
      redirect_to :action => :edit, user_id: @user.subdomain
    else
      flash[:notice] = 'Произошла ошибка, профайл не может быть обновлен'
      render :action => :edit
    end
  end

  def destroy
    user = User.find_by_subdomain(params[:id])
    authorize! :destroy, user

    user.destroy
    redirect_to root_url
  end

  def signup
    @meta_title = ['Регистрация нового пользователя']
    @broads = ['Регистрация']
    @user = User.new

    respond_to do |format|
      format.json { render json: {content: render_to_string(layout: false, formats: [:html])} }
      format.html { render layout: 'clean' }
    end
  end

  def create
    @user = User.new params[:user]
    @user.site = @site

    if @user.save
      @user.confirm = false
      notifier = UserConfirmationNotifier.new(@site)
      notifier.send_confirmation(@user)
      warden.set_user @user
      url = session[:return_to].present? ? session[:return_to] : user_url(@user.subdomain)
      redirect_to url
    else
      render :signup, :layout => 'clean'
    end
  end

  def reconfirm
    if current_user.confirm?
      redirect_to user_url(current_user.subdomain), notice: 'Ваш аккаунт уже подтверждён.'
    else
      notifier = UserConfirmationNotifier.new(@site)
      notifier.send_confirmation(current_user)
      flash[:notice] = 'На указанный вами при регистрации адрес электронной почты было выслано повторное письмо. Следуйте инструкциям в письме и подтвердите регистрацию.'
      redirect_to user_url(current_user.subdomain)
    end
  end

  def restore
    @meta_title = ['Восстановление пароля']
    # render :layout => 'clean'
    respond_to do |format|
      format.json { render json: {content: render_to_string(layout: false, formats: [:html])} }
      format.html { render layout: 'clean' }
    end
  end

  def restore_pwd
    @meta_title = ['Восстановление пароля']
    @user = User.find_by_email params[:email]

    if @user
      @user.update_confirmation_token
      Resque.enqueue(Mailer, 'UserMailer', :restore, @user.id, @site.id)

      flash[:notice] = 'На указанный вами адрес электронной почты было отправлено письмо.<br /> Следуйте инструкциям в письме для восстановления вашего пароля.'.html_safe
    else
      flash[:error] = 'Указанный вами адрес электронной почты не зарегистрирован<br /> или пользователь с указанным адресом электронной почты<br /> не подтвердил свою регистрацию.'.html_safe
    end

    render :action => 'restore', :layout => 'clean'
  end

  def restore_password
    @user = User.where(confirmation_token: params[:id]).first
    unless @user
      flash[:error] = 'Указан неверный токен смены пароля.'
      return redirect_to(root_path)
    end

    @new_password = @user.try(:restore_password!)

    if @new_password
      warden.set_user(@user)
      Resque.enqueue(Mailer, 'UserMailer', :restore_ok, @user.id, @new_password, @site.id)

      redirect_to user_url(@user.subdomain), flash: { notice: "Новый пароль: #{@new_password}" }
    else
      flash[:error] = 'Произошла ошибка восстановления пароля.<br /> Обратитесь в службу поддержки.'.html_safe
      render action: 'restore', layout: 'clean'
    end
  end

  def add_friend_approve
    authorize! :add_friend_approve, User

    @friendship.add_friend params[:user_id]

    redirect_to :back
  end

  def friend_approved
    authorize! :friend_approved, User

    @friendship.approve_friend params[:id]

    redirect_to :back
  end

  def friend_not_approved
    authorize! :friend_not_approved, User

    @friendship.decline_friend params[:id]

    redirect_to :back
  end

  def del_friend
    friend = User.find_by_subdomain!(params[:user_id])
    authorize! :del_friend, friend

    flash[:notice] = @friendship.delete_friend friend
    redirect_to :back
  end

  def messages
    if logged_in?
      @meta_title = ["Переписка с #{@user.login}"]
      @broads = ["Переписка с #{@user.login}"]

      mark_messages_viewed
      @messages = Message.dialog(@user, current_user) if @user && logged_in?
    else
      flash_login_error
      redirect_to login_url(:subdomain => false)
    end
  end

  def new_message
    @meta_title = ['Новое сообщение']
    @broads = ['Новое сообщение']
    @message = @user.messages.new
  end

  def close_message
    message = Message.find(params[:id])
    message.update_attributes(:viewed => true)

    redirect_to :back
  end

  def create_message
    if params[:message]

      message = current_user.messages.not_viewed.find(:all, :conditions => {sender_id: @user.id})
      message.each{|m| m.update_attributes(:viewed => true)} if message

      @user.messages.create!(:sender_id => current_user.id, :title => params[:message][:title], :text => params[:message][:text])
      @user.send_new_message_notification(@site) if @user.notify_new_msg?
    end
    redirect_to :action => 'messages'
  end

  def change_avatar
    @meta_title = ['Редактирование']
    @broads = ['Редактирование']
  end

  def change_password
    @meta_title = ['Смена пароля']
    @broads = ['Смена пароля']
  end

  private
  def init_friendship
    @friendship = Friendship.new current_user
  end

  def find_user
    @user = User.find_by_subdomain! params[:user_id]
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def set_avatar
    if params[:no_avatar] == ['0'] && params[:user] && params[:user][:avatar]
      @user.avatar = params[:user][:avatar]
    elsif params[:no_avatar].include? '1'
      @user.remove_avatar = true
    end
  end

  def flash_login_error
    flash[:login_error] = "Для просмотра профиля пользователя необходимо авторизироваться или <a href='/account/signup'>зарегистрироваться</a>".html_safe
  end

  def mark_messages_viewed
    current_user.messages.not_viewed.where(sender_id: @user.id).update_all(viewed: true)
  end

  def check_signed_in_for_confirm
    unless current_user
      redirect_to root_path, notice: 'Для подтверждения аккаунта необходимо войти.'
    end
  end

  def render_next_page(items)
    list = items.in_groups_of(3).transpose
    render json: {
      col1: render_json_col(list.first),
      col2: render_json_col(list.second),
      col3: render_json_col(list.last),
      page: items.next_page
    }
  end

  def render_json_col(col)
    render_to_string('docs/_json_articles_list', locals: {articles: col}, layout: false, formats: [:html])
  end
end
