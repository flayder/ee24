# encoding : utf-8
require 'spec_helper'

describe Profession do
  let(:profession) { create :profession }
  subject { profession }
  
  it { should be_valid }
end
