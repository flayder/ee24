# encoding : utf-8
module WithCity
  def self.included(base)
    base.class_eval {
      belongs_to :city
      scope :city, lambda {|field| {:conditions => {:city_id => field}}}
    }
  end
end
