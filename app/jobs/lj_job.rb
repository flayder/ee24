require 'livejournal'
require 'lj_tasks'

class LjJob < ResqueJob
  @queue = queue_name

  def self.perform subject, body, account
    unless LjConfig[account]
      raise(CommonApiKeyNotFound.new("lj account #{account} not found"))
    end

    lj = LiveJournal::Tasks.new(
      LjConfig[account]['username'],
      LjConfig[account]['password']
    )

    lj.create(:subject => subject, :body => body)
  end
end
