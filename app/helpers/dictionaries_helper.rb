# encoding : utf-8

module DictionariesHelper
  def dict_show_url(id)
    if @site.voronezh?
      send(params[:model]+'_item_url', id: id)
    else
      @model.path << "/#{id}"
    end
  end

  def selected_letter
    if params[:letter].present?
      params[:letter]
    elsif @word.present?
      @word.letter
    else
      'all'
    end
  end

  def dictionaries_menu
    @site.dictionaries.map do |dict| 
      link_to(
        dict.title, 
        dictionary_objects_path(link: dict.link)
      ).html_safe
    end.join(' | ').html_safe
  end
end
