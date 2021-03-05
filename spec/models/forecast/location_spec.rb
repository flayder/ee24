require 'spec_helper'

describe Forecast::Location do
  let(:location) { create :forecast_location }
  subject { location }

  it { should be_valid }
  its(:district) { should be_kind_of(Forecast::District) }
end
