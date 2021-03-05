# encoding : utf-8
class CommentMailer < ActionMailer::Base
  include SubjectEncoder

  def reply(comment_id)
    @comment = Comment.find comment_id
    @site = Site.find(93)
    @user = @comment.parent.user
    attachments.inline['logo.png'] = File.read("app/assets/images/header_logo.png")

    mail(
      subject: encode_subj("#{@site.domain}: новый ответ на ваш комментарий"),
      to: @user.email,
      from: @site.email,
      :'Return-Path' => @site.email
    )
  end

  def subscribe(comment_id, user_id)
    @comment = Comment.find comment_id
    @user = User.find(user_id)
    @site = Site.find(93)
    attachments.inline['logo.png'] = File.read("app/assets/images/header_logo.png")

    mail(
      subject: encode_subj("#{@site.domain}: новый комментарий"),
      to: @user.email,
      from: @site.email,
      :'Return-Path' => @site.email
    )
  end
end
