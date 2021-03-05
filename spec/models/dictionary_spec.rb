# encoding : utf-8
require 'spec_helper'

describe Dictionary do
  let(:dictionary) { create :dictionary }
  subject { dictionary }
  
  it { should be_valid }
  it { should belong_to(:site) }
  it { should have_many(:rubrics) }
  it { should validate_presence_of(:site_id) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:link) }
end
