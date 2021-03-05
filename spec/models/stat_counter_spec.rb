require 'spec_helper'

describe StatCounter do
  let(:stat_counter) { create :stat_counter }
  subject { stat_counter }

  it { should be_valid }
end
