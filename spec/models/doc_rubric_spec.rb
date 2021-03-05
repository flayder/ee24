# encoding : utf-8
require 'spec_helper'

describe DocRubric do
  let(:doc_rubric) { create :doc_rubric }
  subject { doc_rubric }
  
  it { should be_valid }
  it { should belong_to(:global_rubric) }
  it { should have_many(:docs) }
end
