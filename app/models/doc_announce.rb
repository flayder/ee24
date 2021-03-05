class DocAnnounce < ActiveRecord::Base

  attr_accessible :image, :url

  mount_uploader :image, DocAnnounceUploader

end
