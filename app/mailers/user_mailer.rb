# encoding : utf-8
class UserMailer < ActionMailer::Base
  include SubjectEncoder
  # REFACTOR it should not be here
  MODERATION_NOTIFIABLE = [Catalog, Gallery, Resume, Vacancy, Doc, Event]

  layout 'notification', :only => [:new_message, :friend_request, :friend_approved, :friend_declined, :social_welcome]

  def confirm(user_id, site_id, sent_at = Time.now)
    @user = User.find user_id
    @site = Site.find site_id
    @login = @user.login

    mail(
      subject: encode_subj("#{Settings.portal_domain}: подтверждение регистрации"),
      to: @user.email,
      from: Settings.portal_email,
      :'Return-Path' => Settings.portal_email
    )
  end

  def social_welcome(user_id, site_id)
    @user = User.find user_id
    @site = Site.find site_id

    @login = @user.login

    mail(
      subject: encode_subj("#{Settings.portal_domain}: регистрация"),
      to: @user.email,
      from: Settings.portal_email,
      :'Return-Path' => Settings.portal_email
    )
  end

  def restore(user_id, site_id)
    @user = User.find user_id
    @site = Site.find site_id

    @token = @user.confirmation_token
    @login = @user.login
    mail(
      subject: encode_subj("#{Settings.portal_domain}: восстановление пароля"),
      to: @user.email,
      from: Settings.portal_email,
      :'Return-Path' => Settings.portal_email
    )
  end

  def restore_ok(user_id, new_password, site_id)
    @user = User.find user_id
    @site = Site.find site_id

    @new_password = new_password
    @login = @user.login

    mail(subject: encode_subj("#{Settings.portal_domain}: Новый пароль на портале."),
         to: @user.email, from: Settings.portal_email, :'Return-Path' => Settings.portal_email)
  end

  def new_message(user_id, site_id)
    @user = User.find user_id
    @site = Site.find site_id

    @login = @user.login
    @subdomain = @user.subdomain

    mail(subject: encode_subj("#{Settings.portal_domain}: Новое сообщение."),
         to: @user.email, from: Settings.portal_email, :'Return-Path' => Settings.portal_email)
  end

  def friend_request(user_id, friend_id, site_id, sent_at = Time.now)
    @user = User.find user_id
    friend = User.find friend_id
    @site = Site.find site_id

    @login = @user.login
    @subdomain = @user.subdomain
    @user_id = friend.subdomain
    @user_login = friend.login

    mail(subject: encode_subj("#{Settings.portal_domain}: #{@user_login} хочет добавить Вас в друзья."),
         to: @user.email, from: Settings.portal_email, :'Return-Path' => Settings.portal_email)
  end

  def friend_approved(user_id, friend_id, site_id)
    @user = User.find user_id
    friend = User.find friend_id
    @site = Site.find site_id

    @friend = friend

    mail(subject: encode_subj("Подтверждение дружбы"), to: @user.email,
         from: Settings.portal_email, :'Return-Path' => Settings.portal_email)
  end

  def friend_declined(user_id, friend_id, site_id)
    @user = User.find user_id
    friend = User.find friend_id
    @site = Site.find site_id

    @subject = encode_subj("Ответ на запрос дружбы")
    @friend = friend
    mail(subject: encode_subj("Ответ на запрос дружбы"), to: @user.email,
         from: Settings.portal_email, :'Return-Path' => Settings.portal_email)
  end

  def moderation_notification obj_type, obj_id
    approval_moderation_notification obj_type, obj_id, 'moderation_email_subjects'
  end

  def approval_notification obj_type, obj_id
    approval_moderation_notification obj_type, obj_id, 'approval_email_subjects'
  end

  private
  def approval_moderation_notification obj_type, obj_id, subject_key
    @obj = obj_type.constantize.find obj_id

    mail(
      :subject => encode_subj(I18n.translate("#{subject_key}.new_#{obj_type.underscore}", :title => @obj.title)),
      :to => @obj.user.email,
      :from => Settings.portal_email,
      :"Return-Path" => Settings.portal_email
    )
  end
end
