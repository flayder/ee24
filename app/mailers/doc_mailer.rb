# encoding : utf-8

class DocMailer < ActionMailer::Base
  include SubjectEncoder

  def doc_created(doc_id)
    @site = Site.find_by_domain('420on.cz')
    @doc = @site.docs.find doc_id

    mail(
        subject: encode_subj("#{@site.domain}: добавлена новая статья"),
        to: 'info@420on.cz',
        from: @site.email,
        :'Return-Path' => @site.email
    )
  end

  def doc_approved(doc_id)
    @site = Site.find_by_domain('420on.cz')
    @doc = @site.docs.find doc_id

    mail(
        subject: encode_subj("#{@site.domain}: статья была одобрена"),
        to: 'info@420on.cz',
        from: @site.email,
        :'Return-Path' => @site.email
    )
  end

  def doc_not_approved(doc_id)
    @site = Site.find_by_domain('420on.cz')
    @doc = @site.docs.find doc_id

    mail(
        subject: encode_subj("#{@site.domain}: статья была отправлена на доработку"),
        to: 'info@420on.cz',
        from: @site.email,
        :'Return-Path' => @site.email
    )
  end

  def doc_changed(doc_id)
    @site = Site.find_by_domain('420on.cz')
    @doc = @site.docs.find doc_id

    mail(
        subject: encode_subj("#{@site.domain}: статья была изменена"),
        to: 'info@420on.cz',
        from: @site.email,
        :'Return-Path' => @site.email
    )
  end
end
