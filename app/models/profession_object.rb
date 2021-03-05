class ProfessionObject < ActiveRecord::Base

  attr_accessible

  belongs_to :industry
  belongs_to :profession
  belongs_to :resume
  belongs_to :vacancy

end
