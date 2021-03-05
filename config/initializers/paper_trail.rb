# encoding : utf-8
class Version < ActiveRecord::Base
  include WithSite

  OBJECTS = ['DictionaryObject', 'Doc', 'Event', 'Resume', 'Vacancy', 'Catalog']

  default_scope order('created_at DESC')

  validates :item_type, :inclusion => { :in => OBJECTS }
  validates :event, :inclusion => { :in => %w(update create destroy) }

  attr_accessible :site_id, :object_changes

  belongs_to :author, class_name: 'User', foreign_key: 'whodunnit'

end
