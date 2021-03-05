# encoding : utf-8
module Modules
  module Rss
    def self.included(base)
      super
      base.send :include, ClassMethods
    end

    module ClassMethods
      def rss
        @full = false

        g_rubric = DocGlobalRubric.where(:link => params[:controller]).first
        rubrics = g_rubric.doc_rubrics(:all)
        docs = []
        rubrics.each do |rubric|
          docs += rubric.docs.limit(4).order("created_at DESC")
        end

        generate_rss(docs, g_rubric.title, g_rubric.link)
      end

      def rss_rubric
        rubric = DocRubric.find_by_link(params[:rubric])
        docs = rubric.docs.order("created_at DESC").limit(50)

        g_rubric = DocGlobalRubric.where(:link => params[:controller]).first

        generate_rss(docs, g_rubric.title, g_rubric.link, rubric.title)
      end

      def generate_rss(docs, g_rubric_title, g_rubric_link, rubric_title = '', full = false)
        @docs = docs.sort_by{ |a| a.created_at }.reverse
        rubric_title = (" | " + rubric_title) if !rubric_title.blank?

        @full = full

        @xml = {}
        @xml["title"] = @site.portal_title + " | " + g_rubric_title + rubric_title
        @xml["link"] = "https://" + @site.domain + "/" + g_rubric_link
        @xml["description"] = @site.portal_title + " | " + g_rubric_title + rubric_title
        @xml["created_at"] =  @docs.present? ? @docs.first.created_at.rfc822 : Time.now.rfc822

        headers["Content-Type"] = "application/xml; charset=utf-8"
        render :layout => false, :file => "app/views/application/rss.rss.builder"
      end
    end
  end
end
