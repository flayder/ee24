# encoding : utf-8
require 'spec_helper'

describe UserMailer do
  context 'sending from address' do
    let!(:site) { create :prague_site }
    let!(:confirmation_token) { Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{Time.now.to_s}--") }
    let!(:current_user) { create :user, :not_confirmed, site: site, confirmation_token: confirmation_token }
    let(:mail) { UserMailer.confirm(current_user.id, site.id).deliver }

    it 'sends email on reconfirm action' do
      mail.from.should_not eql(site.email)
    end
  end

  UserMailer::MODERATION_NOTIFIABLE.each do |klass|
    it_behaves_like 'moderation notifiable' do
      let(:obj) { create klass.to_s.underscore.to_sym }
    end

    it_behaves_like 'approval notifiable' do
      let(:obj) { create klass.to_s.underscore.to_sym }
    end
  end
end
