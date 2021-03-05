# encoding : utf-8
module RatableDoc
  
  def self.included(base)
    base.class_eval {
      has_many :ratings, :class_name => 'DocRating',  :foreign_key => 'ratable_id', :as => :ratable
    }
  end

  def rating
    self.ratings.sum(:value)
  end

  def voted_by?(user)
    self.ratings.count(:conditions => ['doc_ratings.user_id = ?', user.id]) > 0
  end
end
