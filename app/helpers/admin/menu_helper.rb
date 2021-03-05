# encoding : utf-8
module Admin::MenuHelper
  def render_admin_flash flash
    flash.keys.map do |type|
      content_tag(
        :div,
        content_tag(:button, '×', class: 'close', :type => 'button', :'data-dismiss' => 'alert') + flash[type],
        class: "alert alert-#{type}"
      )
    end.join.html_safe
  end

  def main_menu_partial(type)
    render partial: "/#{type}/templates/blocks/main_menu"
  end
end
