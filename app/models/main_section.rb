class MainSection < ActiveRecord::Base
  attr_accessible :active, :name, :identity

  validates :name, :identity, presence: true, uniqueness: true
end
