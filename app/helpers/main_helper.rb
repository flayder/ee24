# encoding : utf-8
module MainHelper
  def main_menu
    @site.main_menu_links.by_position
  end
end
