class MainMenuLink < ActiveRecord::Base
  include WithSite

  attr_accessible :css_class, :path, :position, :title, as: :admin

  validates :title, :path, :position, presence: true
  validates :path, url_or_path: true

  scope :by_position, order('position IS NULL, position ASC')
end
