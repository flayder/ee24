# encoding : utf-8
module NewsHelper
  def rss_feed_button(rubric = nil)
    case controller_name
    when "news"
      link_to(image_tag("/images/rss.png"),
              {:controller => controller_name,
              :action => "rubric",
              :id => rubric,
              :format => :rss},
              {class: 'rss_feed_button'}
             )
    when "afisha"
      link_to(image_tag("/images/rss.png"),
              :controller => controller_name,
              :action => "rubric",
              :id => rubric,
              :format => :rss
             )
    when "deathfish"
      link_to(image_tag("/images/rss.png"), "/deathfish.rss")
    when "shopping"
      link_to(image_tag("/images/rss.png"), "/shopping.rss")
    else
      nil
    end
  end
end
