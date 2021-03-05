require 'spec_helper'

describe Forecast::Data do
  let(:data) { create :forecast_data }
  subject { data }

  it { should be_valid }
  its(:location) { should be_kind_of(Forecast::Location) }

  describe '#message' do
    before do
      I18n.translate("forecast_data_message.cloudiness").stub(:[]).and_return('1')
      I18n.translate("forecast_data_message.precipitation_rate").stub(:[]).and_return('2')
      I18n.translate("forecast_data_message.precipitation_type").stub(:[]).and_return('3')
    end

    context 'when thehe is a precipitation' do
      let(:data) { build :forecast_data, icon: 'd111'}

      it 'returns join of cloudiness, precipitation_rate and type' do
        data.message.should eq("1, 23")
      end
    end

    context 'when thehe is no precipitation' do
      let(:data) { build :forecast_data, icon: 'd100'}

      it 'returns message without precipitation_type' do
        data.message.should eq("1, 2")
      end
    end
  end
end

