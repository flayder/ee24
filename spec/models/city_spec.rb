# encoding : utf-8
require 'spec_helper'

describe City do
  let(:city) { create :city }
  subject { city }
  
  it { should be_valid }
end
