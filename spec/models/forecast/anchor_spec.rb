require 'spec_helper'

describe Forecast::Anchor do
  let(:anchor) { create :forecast_anchor }
  subject { anchor }

  it { should be_valid }
end
