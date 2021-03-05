module ForecastHelper
  ICONS = {"d000"=>"d000", "d100"=>"d100", "d200"=>"d100", "d300"=>"d100", "d400"=>"d100", "d210"=>"d220", "d220"=>"d220", "d310"=>"d220", "d320"=>"d220", "d340"=>"d220", "d212"=>"d212", "d222"=>"d212", "d312"=>"d212", "d322"=>"d212", "d211"=>"d211", "d221"=>"d211", "d311"=>"d211", "d321"=>"d211", "n000"=>"n000", "n100"=>"n400", "n200"=>"n400", "n300"=>"n400", "n400"=>"n400", "n210"=>"n410", "n220"=>"n410", "n310"=>"n410", "n320"=>"n410", "n212"=>"n412", "n222"=>"n412", "n312"=>"n412", "n322"=>"n412", "n211"=>"n411", "n221"=>"n411", "n311"=>"n411", "n321"=>"n411", "d440"=>"d440", "n440"=>"d440", "d240"=>"d440", "n240"=>"d440", "n340"=>"d440", "d432"=>"d412", "d600"=>"d600", "n600"=>"d600", "d500"=>"d600", "n500"=>"d600", "n410"=>"d410", "d410"=>"d410", "d420"=>"d420", "n420"=>"d410", "d430"=>"d410", "n430"=>"d410", "d412"=>"d412", "d422"=>"d422", "n412"=>"d412", "n422"=>"d412", "n432"=>"d412", "d411"=>"d421", "d421"=>"d421", "d431"=>"d421", "n411"=>"d421", "n421"=>"d421", "n431"=>"d421"}

  def big_icon(forecast_data)
    icon_name = ICONS[forecast_data.icon]
    image_tag("weather/icons/110x155/#{icon_name}.png")
  end

  def small_day_icon(forecast_data)
    icon = forecast_data.icon[/\d{3}/].prepend('d')
    icon_image_tag(icon)
  end

  def small_night_icon(forecast_data)
    icon = forecast_data.icon[/\d{3}/].prepend('n')
    icon_image_tag(icon)
  end

  def small_icon(forecast_data)
    icon_image_tag(forecast_data.icon)
  end

  def number_with_degree(number)
    "#{number_with_sign(number)}&deg;".html_safe
  end

  def background_image(forecast_data, site)
    if forecast_data
      icon = site.forecast_icons.with_background.find_by_name(ForecastHelper::ICONS[forecast_data.icon])
    end

    image_url = if icon.try(:background_url)
                  icon.background_url
                elsif site.forecast_settings.background_url
                  site.forecast_settings.background_url
                end

    if image_url
      content_tag(:div,
        content_tag(:div, image_tag(image_url, class: "back-image"), class: 'back-center'),
      class: 'back')
    end
  end

  private
  def icon_image_tag(icon)
    image_tag("weather/icons/30x30/#{icon}.png")
  end
end
