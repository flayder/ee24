class FooterBlock < ActiveRecord::Base
  attr_accessible :content, :identity, :name

  validates :name, :identity, presence: true, uniqueness: true
end
