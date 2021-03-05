class MainMenuLinkSweeper < ActionController::Caching::Sweeper
  include WithMainPageExpiration
  observe MainMenuLink

  def after_update main_menu_link
    exprire_main_page main_menu_link
  end

  def after_destroy main_menu_link
    exprire_main_page main_menu_link
  end

  def after_create main_menu_link
    exprire_main_page main_menu_link
  end
end
