# encoding : utf-8
module Modules
  module WithPreviewAction
    def self.included(base)
      base.class_eval {
        before_filter :for_preview, :only => :preview
      }
    end

    def for_preview
      if params[:object].present? && has_access?
        @doc = Doc.find_or_initialize_by_id(params[:object_id])
        @doc.attributes = params[:object]

        @rubric = @doc.rubric
        @doc.approved = false
        block_micro_gallery(@doc)
        @text = @doc.text
        @comment = @doc.comments.new

        if model == Doc
          @broads = [['Проверка', '/test/'], [@rubric.title, "/test/#{@rubric.link}" ], @doc.title]
        else
          @broads = [['Новости', '/news/'], [@rubric.title, "/news/#{@rubric.link}" ], @doc.title]
        end
        #yield if block_given?
      else
        redirect_to root_url
        return false
      end
    end

  end
end
