# encoding : utf-8
module WithParam
  def self.included(base)
    base.class_eval {
      validates :title, :uniqueness => { :scope => [:site_id, :approved] }
      validates_uniqueness_of :param, :scope => :site_id
      before_validation :generate_param, :if => :title?
    }
  end

  def to_param
    "#{self.id}-#{self.param}"
  end

  def generate_param
    if self.has_attribute?(:language)
      current_locale = I18n.locale
      I18n.locale = self.language
      self.param = self.title.parameterize
      I18n.locale = current_locale
    else
      self.param = self.title.parameterize
    end
  end
end
