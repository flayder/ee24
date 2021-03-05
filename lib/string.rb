# encoding : utf-8
class String
  def to_url
    Russian.translit(self).strip.downcase.gsub(/[^a-z0-9\-]/,'-')
  end
end
