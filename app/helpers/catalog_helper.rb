# encoding : utf-8
module CatalogHelper

  def catalog_rubric_icon(rubric)
    icon = "v2/catalog/#{rubric.id}.png"
    icon = File.exists?(Rails.root.join('app', 'assets', 'images', icon)) ? icon : "icons/folder.png"
  end  

end