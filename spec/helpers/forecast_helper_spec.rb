# encoding : utf-8
require 'spec_helper'

describe ForecastHelper do
  describe '#background_image' do
    let!(:site) { create :site }
    let!(:settings) { site.forecast_settings }
    let!(:forecast_data) { create :forecast_data }
    let(:icon_name) { ForecastHelper::ICONS[forecast_data.icon] }
    let!(:forecast_icon) { create :forecast_icon, site: site, name: icon_name }

    context 'with default (settings) background' do
      before do
        settings.background = fixture_file('ava.jpg')
        settings.save
      end

      it 'returns no image tag' do
        background_image(forecast_data, site).should include('ava.jpg')
      end
    end

    context 'with icon background' do
      before do
        settings.background = fixture_file('ava.jpg')
        settings.save
        forecast_icon.background = fixture_file('ava2.jpg')
        forecast_icon.save
      end

      it 'returns no image tag' do
        background_image(forecast_data, site).should include('ava2.jpg')
      end
    end

    context 'without background' do
      it 'returns no image tag' do
        background_image(forecast_data, site).should be_nil
      end
    end
  end
end
