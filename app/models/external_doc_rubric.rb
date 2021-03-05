class ExternalDocRubric < ActiveRecord::Base
  include WithSite

  attr_accessible :position, :title, as: :admin
  has_many :external_docs, order: "created_at DESC", dependent: :destroy, foreign_key: :external_doc_rubric_id
  has_one :main_block_rubric, as: :rubric, dependent: :destroy
  validates :title, presence: true
end
