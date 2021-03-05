# encoding : utf-8
class Message < ActiveRecord::Base
  scope :to_user, ->(user) { where(user_id: user.id) }
  scope :sender, lambda { |field| where(sender_id: field.id) }
  scope :dialog, lambda {|user1, user2| {:conditions => ["(user_id = ? AND sender_id = ?) OR (user_id = ? AND sender_id = ?)", user1.id, user2.id, user2.id, user1.id], :order => "created_at DESC"}}
  scope :answer, lambda {|date, user_partner_ids, user_id|
    { :conditions => ["created_at > ? AND user_id = ? AND sender_id in (?)",
      date, user_id, user_partner_ids],
      :order => "created_at ASC" }
  }
  scope :not_viewed, where(viewed: false)

  validates :sender_id, exclusion: { in: Proc.new { |m| [m.user_id] } }

  belongs_to :sender, :class_name => "User", :foreign_key => "sender_id"
  belongs_to :receiver, :class_name => "User", :foreign_key => "user_id"

  attr_accessible :title, :text, :sender_id, :admin, :viewed, :buttons
end
