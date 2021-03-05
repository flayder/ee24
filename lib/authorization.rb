# encoding : utf-8
module Authorization
  protected
  
  def current_ability
    @current_ability ||= Ability.new(current_user, @site.id)
  end
end
