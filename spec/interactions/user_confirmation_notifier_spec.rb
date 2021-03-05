# encoding : utf-8
require 'spec_helper'

describe UserConfirmationNotifier do
  let!(:site) { create :site }
  let(:notifier) { UserConfirmationNotifier.new(site) }
  let!(:user) { create :user, :not_confirmed, site: site, created_at: rand(1.day).ago }

  before do
    ResqueSpec.reset!
  end

  describe '#send_confirmation' do
    before { notifier.send_confirmation(user) }

    it 'queues confirmations email' do
      Mailer.should have_queue_size_of(1)
      Mailer.should have_queued('UserMailer', :confirm, user.id, site.id)
    end
  end

  describe '#send_reminders' do
    let!(:old_user) { create :user, :not_confirmed, site: site, created_at: Time.now - 1.week }
    let!(:confirmed_user) { create :user, site: site }

    before { notifier.send_reminders! }

    it 'queues reminders for all not confirmed users created 24 hours ago' do
      Mailer.should have_queue_size_of(1)
      Mailer.should have_queued('UserMailer', :confirm, user.id, site.id)
    end
  end
end
