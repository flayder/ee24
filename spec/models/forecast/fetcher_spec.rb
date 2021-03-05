require 'spec_helper'

describe Forecast::Fetcher do
  let(:site) { create :site }
  let(:fetcher) { Forecast::Fetcher.new site }
  let(:stub_forecast_day_data) { fixture_file('foreca/day.xml') }
  let(:stub_forecast_3hour_data) { fixture_file('foreca/3hour.xml') }
  let(:stub_forecast_current_data) { fixture_file('foreca/current.xml') }
  let(:district) { create :forecast_district, site: site }
  let!(:location) { create :forecast_location, district: district, foreca_id: '100466806' }

  describe '#fetch_day!' do
    before do
      fetcher.stub(:download_data).with('day').and_return(stub_forecast_day_data)
    end

    it 'loads locations forecasts' do
      expect {
        fetcher.fetch_day!
      }.to change(Forecast::Data, :count).by(10)
    end
  end

  describe '#fetch_3hour!' do
    pending 'Do we need 3hour forecasts?'
    # before do
    #   fetcher.stub(:download_data).and_return(stub_forecast_3hour_data)
    # end

    # it 'loads locations forecasts' do
    #   expect {
    #     fetcher.fetch!
    #   }.to change(Forecast::Data, :count).by(10)
    # end
  end

  describe '#fetch_current!' do
    before do
      fetcher.stub(:download_data).with('cc').and_return(stub_forecast_current_data)
    end

    it 'loads locations forecasts' do
      expect {
        fetcher.fetch_current!
      }.to change(Forecast::Data, :count).by(1)
    end
  end
end
