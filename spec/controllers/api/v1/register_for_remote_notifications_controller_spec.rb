# encoding : utf-8
require 'spec_helper'

describe Api::V1::RegisterForRemoteNotificationsController do
  context "with request.header key" do
    before(:each) do
      request.env["HTTP_ACCEPT"] = 'application/json'
      request.env["api-key"] = "cb5e100e5a9a3e7f6d1fd97512215282"
    end

    context "creates tokens" do
      it 'creates the device by a json format' do
        lambda {
          post :create, mobile_device: { token: 'Charlie' }
        }.should change(MobileDevice, :count).by(1)
        response.should be_success
        response.status.should eq(200|201)
      end

      context "from satellite site" do
        let!(:site) { create :site }
        let!(:satellite) { create :satellite }
        let!(:mobile_device) { create :mobile_device, site: site }

        before { @request.host = satellite.domain }

        it 'creates new record with the same token' do
          lambda {
            post :create, mobile_device: { token: mobile_device.token }
          }.should change(MobileDevice, :count).by(1)
          response.should be_success
          response.status.should eq(200|201)
        end
      end
    end

    context 'validations' do
      it 'validates device attrs' do
        lambda {
          post :create, mobile_device: { token: '' }
        }.should_not change(MobileDevice, :count)


        response.should_not be_success
        response.status.should eq(422)
        response.body["token"].should_not be_nil
      end
    end
  end

  context "with wrong header key" do
    before { request.env["api-key"] = "wrong" }

    it 'not create the device record' do
      lambda {
        post :create, mobile_device: { token: 'Tommy' }
      }.should_not change(MobileDevice, :count)
      response.status.should > 400
    end
  end
end
