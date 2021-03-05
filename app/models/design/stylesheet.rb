class Design::Stylesheet < ActiveRecord::Base
  include WithSite

  attr_accessible :body, :name

  validates :name, :body, presence: true
  validates :name, uniqueness: { scope: :site_id }
end
