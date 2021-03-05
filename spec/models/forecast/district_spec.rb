require 'spec_helper'

describe Forecast::District do
  let(:anchor) { create :forecast_anchor }
  subject { anchor }

  it { should be_valid }
end
