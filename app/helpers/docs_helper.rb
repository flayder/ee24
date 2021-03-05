# encoding: utf-8
module DocsHelper
  def render_main_block(main_block)
    render "main/#{main_block.doc_type.underscore.pluralize}", docs: main_block.docs
  end
end
