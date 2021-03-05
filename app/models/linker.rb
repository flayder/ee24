# encoding : utf-8
class Linker < ActiveRecord::Base
  include WithSite

  attr_accessible :url, :counter, :seo_text, as: :admin

  def self.find_linker(url)
    linker = Linker.find_by_url(url) || Linker.create_linker(url)
    linker.increment!('counter') if linker
    return linker
  end

  def self.create_linker(url)
    linker = Linker.where("url IS NULL OR url = ''").first
    linker.update_attribute(:url, url) if linker
    return linker
  end
end
