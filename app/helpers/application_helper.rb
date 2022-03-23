# encoding : utf-8
module ApplicationHelper
  include NumWorder

  LANGUAGE_LIST = {ru: {ru: 'Русский', en: 'English'},
                   en: {ru: 'Russian', en: 'English'}}

  def article_text(doc)
    text = doc.text.gsub(/<p>[\s$]*<\/p>/, '')
    text.gsub!('<!--request_form-->', render(partial: 'templates/dynamic/doc_request_form', locals: { doc: doc })) if text.include?('<!--request_form-->')
    text.html_safe
  end

  # Helper for model method human_attribute_name
  def han(model, attribute)
    model.to_s.classify.constantize.human_attribute_name(attribute)
  end

  def hmn(model, options = {})
    model.to_s.classify.constantize.send(:model_name).human(options)
  end

  def vk_app_id
    # TODO Need clear this method from application
    ""
  end

  def hypercomments_widget_id
    Settings.hypercomments_widget_id[@site.domain]
  end

  def image_for_article(article)
    image_tag(article.main_photo.image.url(:large), size: '295x200')
  end

  def active_date(day, date, path)
    day_name = if day == Date.today
      "Сегодня"
    elsif day == 1.day.ago.to_date
      "Вчера"
    elsif day == 1.day.from_now.to_date
      "Завтра"
    else
      raw "#{content_tag(:strong, Russian.strftime(day, "%a"))} #{day.strftime("%e.%m")}"
    end

    if day == date
      content_tag(:div, day_name, class: "g-date active")
    else
      link_to day_name, day.strftime("/#{path}/date/%Y/%m/%d"), class: 'g-date'
    end
  end

#  def hypercomments_widget
#    widget = @site.social_widget_codes.find_by_widget_type('hypercomments')
#    widget.present? ? widget.code : ''
#  end

  def comments_needed_for?(doc)
    @site.has_section?(:comments) and doc.respond_to?(:is_commentable) and doc.is_commentable? and hypercomments_widget_id.present?
  end

  def favicon
    content_tag(:link, nil, :rel => "icon", :type => "image/gif", :href => @site.favicon.url)
  end

  def generate_rubric_select(controller)
    Rubricator.generate_select(@site, controller)
  end

  #заглушка
  def url_for_file_column(item, field, size = nil)
    item = instance_variable_get("@#{item}") if item.is_a?(String)
    photo = item.send(field)

    photo.url(size) if photo
  end

  def will_paginate(collection_or_options = nil, options = {})
    head_content = ""
    if collection_or_options
      if collection_or_options.current_page > 1
        head_content += "<link rel=\"prev\" href=\"#{url_for(params.merge(only_path: false, page: collection_or_options.current_page - 1))}\">"
      end
      if collection_or_options.current_page < collection_or_options.total_pages
        head_content += "<link rel=\"next\" href=\"#{url_for(params.merge(only_path: false, page: collection_or_options.current_page + 1))}\">"
      end
    end

    content_for :head, head_content.html_safe if head_content.present?
    super *[collection_or_options, options].compact
  end

  def will_paginate_new(collection = nil, options = {})
    options[:renderer] = OnruLinkRenderer::LinkRenderer
    will_paginate collection, options
  end

  def will_paginate_bootstrap(collection = nil, options = {})
    options[:renderer] = BootstrapLinkRender::LinkRenderer
    will_paginate collection, options
  end

  def error_messages_for(object_name, options = {})
    object = options.delete(:object)
    object ||= instance_variable_get("@#{object_name}")
    if object.errors.present?
      error_messages = object.errors.full_messages.map {|msg| content_tag(:li, ERB::Util.html_escape(msg)) }
      contents = content_tag(:ul, raw(error_messages.join))
      content_tag(:div, content_tag(:div, 'Ошибки:', class: 'errorExplanationHeader') + contents.html_safe, {:id => 'errorExplanation', class: 'errorExplanation'})
    end
  end

  def ads_needed?
    !(@layout_params && @layout_params[:no_banners])
  end

  def account_url(params = {})
    if params.is_a?(User)
      subdomain = params.subdomain
    elsif params.is_a?(Hash)
      subdomain = params[:subdomain]
    end
    subdomain.present? ? user_url(:id => subdomain) : '#'
  end

  def default_avatar_path(user, size)
    avatar_path = "/assets/user_icon/no_avatar_"
    avatar_path += user.gender
    avatar_path += size == "small" ? "_50.jpg" : "_100.jpg"
    return avatar_path
  end

  def avatar_url(user, size="avatar")
    if user.avatar?
      user.avatar.url(size)
    else
      default_avatar_path(user, size)
    end
  end

  def avatar_img(user, size = "avatar")
    return "<img src='#{avatar_url(user, size)}' class='avatar' alt='#{user.login}'>"
  end

  def avatar_or_anonym(user, size = 'small')
    user ? avatar_img(user, size) : image_tag('/images/user_icon/no_avatar_male_50.jpg', class: 'avatar')
  end

  def strip_and_cut(str, len)
    truncate(str, :length => len, :separator => ' ')
  end

  def timeleft created_at
    if created_at >= Time.now - 1.minute
      "менее минуты назад"
    elsif created_at > Time.now - 20.minutes
      min = ((Time.now - created_at) / 60).to_i
      num_in_words(min, 2) + ' ' + Russian.p(min, "минута", "минуты", "минут") + " назад"
    elsif created_at.to_date == Date.today
      "Сегодня #{Russian::strftime(created_at, "%H:%M")}"
    elsif created_at.to_date == Date.today - 1.day
      "Вчера #{Russian::strftime(created_at, "%H:%M")}"
    else
      Russian::strftime(created_at, "%d %B %H:%M")
    end
  end

  # META

  def meta_title(raw = false)
    title = if @meta_title
      @meta_title.is_a?(Array) ? h(@meta_title.reverse.join(' / ')) : @meta_title
    elsif @seo
      @seo.title
    end

    title << " - страница #{params[:page]}" if title && params[:page]

    raw ? title : "<title>#{title}</title>"
  end

  def simple_title
    @meta_title.is_a?(Array) ? h(@meta_title.last) : @meta_title
  end

  def meta_keywords
    if @meta_keywords
      content = "#{h(@meta_keywords)}"
    elsif @seo
      content = @seo.keywords
    elsif @meta_keywords == "none" || @meta_keywords.blank?
      content = nil
    end

    "<meta name=\"keywords\" content=\"#{content}\" >"
  end

  def meta_news_keywords
    "<meta name=\"news_keywords\" content=\"#{@seo.try(:news_keywords)}\" >"
  end

  def meta_description
    # REFACTOR we really need check for 'none' value??
    if @meta_description
      content = @meta_description
    elsif @seo
      content = @seo.description
    elsif @meta_description == "none" || @meta_description.blank?
      content = nil
    end
    stripped_content = strip_tags(content).html_safe if content

    "<meta name=\"description\" content=\"#{stripped_content}\" >"
  end

  def og_description
    @meta_description.blank? ? @seo.try(:description) : @meta_description
  end

  def yandex_confirmation_meta
    confirmation_codes = YAML.load_file(File.join(Rails.root, "config", "yandex_confirmation_meta.yml"))
    confirmation_codes[@site.domain].present? ? "<meta name='yandex-verification' content='#{confirmation_codes[@site.domain]}' />" : ""
  end

  def is_admin_or_editor
    @admin_access or (logged_in? and current_user.is_editor?)
  end

  def voronezh?
    @site.domain == '36on.ru'
  end

  def is_partner_portal?
    @site.is_partner?
  end

  #отображать ли для пользователя время генерации страницы
  def display_generation_time
    @page_generation_start_time && has_access?
  end

  #админ, модератор, редактор (доступ к административным ф-ям)
  def has_access?
    logged_in? and current_user.has_access
  end

  def is_admin_or_editor?
    @admin_access || (logged_in? && current_user.is_editor?)
  end

  def is_site_admin_or_editor?
    @admin_access || (logged_in? && current_user.has_privileges?(@site))
  end

  def site_menu site
    site.menu_sections.map do |section|
      link_to_current(section.title, "/#{section.is_a?(Section) ? section.controller : section.link}")
    end.join('')
  end

  def web_analytics site
    if site.present?
      raw(site.web_analytics_blocks.invisible.map(&:body).join("\n"))
    else
      ''
    end
  end

  def yandex_direct_code site
    if code = YandexDirectCodes[site.domain]
      raw(YandexDirectCodes[site.domain])
    end
  end

  def tb value, hash
    hash[value.to_s.to_sym]
  end

  def seo_text seo
    render :partial => 'shared/seo_text', locals: { seo: seo } unless params[:page].present? && params[:page] > 1
  end

  def seo_about seo_about
    render :partial => 'shared/seo_about', locals: { seo_about: seo_about } unless params[:page].present? && params[:page] > 1
  end

  def seo_sub_text seo_sub_text
    render :partial => 'shared/seo_sub_text', locals: { seo_sub_text: seo_sub_text } unless params[:page].present? && params[:page] > 1
  end

  def ad_code(format)
    unless @ad_codes[format].present?
      #ищем дефолтный рекламный код
      banner = AdCode.site(@site.id).where(:banner_type => format, :url => nil, :ad_section_id => @site.id, :ad_section_type => 'Site').first
      @ad_codes[format] ||= banner.code if banner.present?
    end
    @ad_codes[format] if @ad_codes[format].present?
  end

  def cache_unless_admin *args
    if logged_in? && (current_user.has_privileges?(@site) || params[:action] == 'my')
      yield
    else
      cache *args do
        yield
      end
    end
  end

  def yandex_header
    "<script src=\"//api-maps.yandex.ru/2.0-stable/?load=package.full&amp;lang=ru-RU\" type=\"text/javascript\"></script>"
  end

  def liquidize template_name, *args
    Liquid::Template.parse(@site.design_templates.find_by_name!(template_name).body).render(*args)
  end

  def link_to_current(name, options = {}, html_options = {})
    if current_page?(options) || (options.is_a?(Hash) && options[:controller].present? && current_page?(options[:controller]))
      content_tag(:span, name, class: 'active')
    else
      link_to(name, options, html_options)
    end
  end

  def link_to_unless_current_account(name, options = {}, html_options = {})
    if current_page?(options) || (options.is_a?(Hash) && options[:controller].present? && current_page?(options[:controller]))
      html_options[:class] << ' active'
    end
    link_to(content_tag(:span, name, class: 'title'), options, html_options)
  end

  def link_to_active_with_counter(name, counter, options = {}, html_options = {})
    if current_page?(options) || (options.is_a?(Hash) && options[:controller].present? && current_page?(options[:controller]))
      html_options[:class] << ' active'
    end
    link_to(options, html_options) do
      # https://robots.thoughtbot.com/nesting-content-tag-in-rails-3
      if counter.to_i > 0
        concat(content_tag(:span, counter, class: 'counter'))
      end
      concat(content_tag(:span, name, class: 'title'))
    end
  end

  def show_breadcrumbs
    broad = [link_to("Главная", root_url)]
    broad_links = 0
    if @broads && controller_name != "main"
      if @broads.is_a?(Array)
        @broads.each do |br|
          if br.is_a?(Array)
            broad_links += 1
            broad << link_to(h(br.first), br[1])
          else
            broad << h(br)
          end
        end
      else
        broad << @broads
      end
    end
    if broad_links > 0
      broad.join("#{content_tag(:span, '&gt;&gt;'.html_safe)}").html_safe
    else
      nil
    end
  end

  def number_with_sign(number)
    return '' unless number
    number > 0 ? "+#{number}" : number
  end

  def link_if_logged(essense, url, block = true)
    if logged_in?
      link = url
      jump = ''
    else
      link = new_session_path
      jump = 'js-jump'
    end
    link_to "#{t('helpers.link.add')} #{essense}", 'javascript:;', data: {link: link}, class: "g-button primary seo-link #{'block medium' if block} #{jump}"
  end

  def link_to_with_count(text, url, count, html_options = {})
    html_options[:class] = [html_options[:class], ('any' if count > 0), ('active' if current_page?(url))]
    bold = html_options.delete(:bold)
    link_to "#{text}#{count > 0 ? (bold ? " <b>#{count}</b>" : " (#{count})") : ''}".html_safe, url, html_options
  end

  def not_approved_count(key, from)
    begin
      if [:news, :realty, :magazine, :travel, :immigration].include?(key)
        Doc.global_rubric(@site.doc_global_rubrics.find_by_link(key))
      elsif key == :photo
        Gallery.site(@site)
      elsif key == :afisha
        Event.site(@site)
      elsif key == :questions
        key.to_s.classify.constantize.not_approved
      else
        key.to_s.classify.constantize.site(@site).not_approved
      end.not_approved.send("#{from}_generated").count
    rescue Exception
      0
    end
  end
end
