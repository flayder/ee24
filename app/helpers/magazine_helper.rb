# encoding : utf-8
module MagazineHelper

  def rss_links_folder
    if params[:controller].include?('travel')
      'news'
    elsif params[:controller].include?('magazine')
      'magazine'
    else
      params[:controller]
    end
  end

end
