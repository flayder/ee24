# encoding : utf-8
require 'timeout'
require 'grocer'
require 'spec_helper'

describe "apple push notifications" do
  let!(:site) { create :prague_site }
  let!(:news_section) { create :section, controller: 'docs' }
  let!(:site_section) { create :site_section, site: site, section: news_section }
  let!(:doc_rubric) { create :doc_rubric, site: site, global_rubric: doc_global_rubric }
  let!(:doc_global_rubric) { create :doc_global_rubric, site: site }
  let!(:user) { create :user }
  let!(:doc) { create :doc, doc_rubric_id: doc_rubric.id, user: user,
                      site: site, approved: true }

  let!(:device) { create :mobile_device, site: site}

  let(:server) { Grocer.server(port: 2195) }

  before { server.accept }
  after { server.close }

  it "sends on APNS server the following data" do
    apns = Mobile::ApplePushNotification.new
    apns.send

    Timeout.timeout(3) do
      notification = server.notifications.pop

      notification.alert.should eq(doc.title)
      notification.device_token.should eq(device.token)
      notification.custom[:doc_id].should eq(doc.id)
      notification.custom[:rubric_id].should eq(doc.doc_rubric_id)
    end
  end
end
