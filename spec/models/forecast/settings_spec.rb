require 'spec_helper'

describe Forecast::Settings do
  let(:site) { create :site }
  let(:settings) { site.forecast_settings }
  subject { settings }

  it { should be_valid }
end
