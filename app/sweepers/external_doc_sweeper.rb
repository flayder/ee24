class ExternalDocSweeper < ActionController::Caching::Sweeper
  include WithMainPageExpiration
  observe ExternalDoc

  def after_update doc
    exprire_main_page doc
  end

  def after_destroy doc
    exprire_main_page doc
  end

  def after_create doc
    exprire_main_page doc
  end
end
