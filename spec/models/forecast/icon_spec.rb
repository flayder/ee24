require 'spec_helper'

describe Forecast::Icon do
  let(:icon) { create :forecast_icon }
  subject { icon }

  it { should be_valid }
end
