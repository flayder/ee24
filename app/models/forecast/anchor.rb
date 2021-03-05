class Forecast::Anchor < ActiveRecord::Base
  attr_accessible :limit, :text

  has_many :widgets

  validates :limit, :text, presence: true
end
