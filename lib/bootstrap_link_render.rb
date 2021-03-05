# encoding : utf-8
module BootstrapLinkRender
  class LinkRenderer < WillPaginate::ActionView::LinkRenderer

    protected

    private

    def html_container(html)
      tag :ul, html, container_attributes
    end

    def page_number(page)
      tag :li, link(page, page, rel: rel_value(page)), class: ('active' if page == current_page)
    end

    def gap
      tag :li, link('&hellip;'.html_safe, '#'), class: 'disabled'
    end

    def previous_or_next_page(page, text, classname)
      tag :li, link(text, page || '#'),
    class: [(classname[0..3] if  @options[:page_links]), (classname if @options[:page_links]), ('disabled' unless page)].join(' ')
    end

  end
end
