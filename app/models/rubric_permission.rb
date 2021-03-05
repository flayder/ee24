class RubricPermission < ActiveRecord::Base
  attr_accessible :rubric_id, :rubric_type, :site_admin_id

  belongs_to :rubric, :polymorphic => true
  belongs_to :site_admin

  validates :rubric_id, :rubric_type, :site_admin, :presence => true
end