# encoding : utf-8
require 'spec_helper'

describe EventRubric do
  let(:event_rubric) { create :event_rubric }
  subject { event_rubric }
  
  it { should be_valid }
end
