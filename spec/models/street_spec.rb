# encoding : utf-8
require 'spec_helper'

describe Street do
  let(:street) { create :street } 
  subject { street }
  
  it { should be_valid }
end
