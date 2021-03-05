# encoding : utf-8
require 'spec_helper'

describe StaticDoc do
  let(:static_doc) { create :static_doc }
  subject { static_doc }
  
  it { should be_valid }
  it { should belong_to(:site) }
end
