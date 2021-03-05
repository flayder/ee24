require 'spec_helper'

describe Ip do
  let(:ip) { create :ip }
  subject { ip }

  it { should be_valid }
end