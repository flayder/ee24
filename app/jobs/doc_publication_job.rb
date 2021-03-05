# encoding : utf-8
class DocPublicationJob < ResqueJob
  @queue = queue_name

  def self.perform doc_id
    ActiveRecord::Base.verify_active_connections!

    doc = Doc.find doc_id
    doc.update_column(:approved, true)
  end
end
