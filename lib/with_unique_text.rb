require 'digest/md5'

module WithUniqueText
  def self.included(base)
    base.class_eval {
      validates :text_hash, :presence => true
      validates :text, uniqueness: true
      validates :text_hash, uniqueness: true
      before_validation :generate_text_hash, :if => :text
    }
  end

  private
  def generate_text_hash
    self.text_hash = Digest::MD5.hexdigest self.text
  end
end