class ExternalDoc < ActiveRecord::Base
  include WithSite
  include WithApproved
  include WithMain

  attr_accessible :url, :main, :title, :external_doc_rubric_id,
                  :approved, :image, :remove_image, :image_cache, as: :admin

  belongs_to :external_doc_rubric
  belongs_to :rubric, class_name: 'ExternalDocRubric', foreign_key: :external_doc_rubric_id
  belongs_to :user

  validates :title, :url, :site_id, :external_doc_rubric_id, :user_id, presence: true
  validates :url, url: true, uniqueness: { scope: :site_id }

  mount_uploader :image, ExternalDocImageUploader

  scope :by_language, lambda {} #{ where(language: I18n.locale.to_s) }

  def main_photo
    self
  end
end
