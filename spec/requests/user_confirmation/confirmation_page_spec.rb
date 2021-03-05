# encoding:utf-8
require 'spec_helper'

describe 'confirmation page' do
  let!(:site) { create :prague_site }
  let(:confirmation_token) { Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{Time.now.to_s}--") }
  let(:current_user) { create :user, :not_confirmed, site: site, confirmation_token: confirmation_token }
  let(:mail) { UserMailer.confirm(current_user.id, site.id) }
  let(:message) { Faker::Lorem.sentence }
  let(:notifier) { UserConfirmationNotifier.new(site) }

  before do
    Rails.cache.clear
    login current_user
  end

  context 'when unconfirmed' do
    let(:confirmation_url) { "/users/#{current_user.subdomain}/confirm?confirmation_token=#{current_user.confirmation_token}" }

    it 'has reconfirmation link' do
      visit user_not_confirm_path(current_user.subdomain)
      page.should have_link("отправить повторное письмо", user_reconfirm_path(current_user.subdomain))
    end

    it 'sends email on reconfirm action' do
      notifier.send_confirmation(current_user).should be_true

      from_addr = mail.from_addrs
      to_addrs = mail.to_addrs
      mail.from.should eq(from_addr)
      mail.to.should eq(to_addrs)
      mail.body.encoded.should include(confirmation_url)
    end

    it 'confirms user' do
      visit confirmation_url
      current_user.reload.confirm.should be_true
      current_user.reload.confirmation_token.should be_nil
      current_user.reload.confirmed_at.should_not be_blank
      current_user.reload.confirmed_at.should be >= current_user.created_at
    end

    it 'redirects on root path unless user not signed in' do
      visit user_not_confirm_path(current_user.subdomain)
      click_link("ВЫХОД")
      current_path.should == root_path
      page.should have_content("Для подтверждения аккаунта, необходимо войти")
    end
  end

  context 'when confirmed' do
    let(:current_user) { create :user, site: site }

    it 'cannot confirm twice' do
      visit user_not_confirm_path(current_user.subdomain)
      current_path.should == root_path
    end
  end
end
