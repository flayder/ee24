# encoding : utf-8
module OnruLinkRenderer
  class LinkRenderer < WillPaginate::ActionView::LinkRenderer
    private
    def link(text, target, attributes = {})
      if target.is_a? Fixnum
        attributes[:rel] = rel_value(target)
        target = target == 1 ? url(nil) : url(target)
      end
      attributes[:href] = target
      tag(:a, text, attributes)
    end
  end
end