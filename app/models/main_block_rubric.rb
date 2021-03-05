#encoding: utf-8
class MainBlockRubric < ActiveRecord::Base
  attr_accessible :main_block_id, :rubric_id, :rubric_type, as: :admin

  belongs_to :main_block
  belongs_to :rubric, polymorphic: true

  validate :uniq_rubric_type

  private
  def uniq_rubric_type
    if main_block && main_block.main_block_rubrics.pluck(:rubric_type).uniq.size > 1
      errors.add(:rubric_type, 'В блоке на главной должны быть рубрики только одного типа.')
    end
  end
end
