require 'spec_helper'

describe AdCode do
  let(:ad_code) { create :ad_code }
  subject { ad_code }

  it { should be_valid }
end
