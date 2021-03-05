class BlackListWord < ActiveRecord::Base
  attr_accessible

  validates :lemma, presence: true, uniqueness: true
end
