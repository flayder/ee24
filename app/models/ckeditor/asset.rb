# encoding : utf-8
class Ckeditor::Asset < ActiveRecord::Base
  include Ckeditor::Orm::ActiveRecord::AssetBase

  delegate :url, :current_path, :size, :content_type, :filename, :to => :data

  attr_accessible :data_file_name, :data_content_type, :data_file_size, :assetable_id, :assetable_type, :type

  validates_presence_of :data
end
